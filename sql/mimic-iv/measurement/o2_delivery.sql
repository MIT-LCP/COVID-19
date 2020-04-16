with ce_stg1 as
(
  SELECT
      ce.stay_id
    , ce.charttime
    , CASE
        -- merge o2 flows into a single row
        WHEN itemid IN (223834, 227582, 224691) THEN 223834
      ELSE itemid END AS itemid
    , value
    , valuenum
    , valueuom
    , storetime
  FROM `physionet-data.mimic_icu.chartevents` ce
  WHERE ce.value IS NOT NULL
  AND ce.stay_id IS NOT NULL
  AND ce.itemid IN
  (
      223834 -- o2 flow
    , 227582 -- bipap o2 flow
    , 224691 -- Flow Rate (L)
    -- additional o2 flow is its own column
    , 227287 -- additional o2 flow
  )
)
, ce_stg2 AS
(
  select
      ce.stay_id
    , ce.charttime
    , itemid
    , value
    , valuenum
    , valueuom
    -- retain only 1 row per charttime
    -- prioritizing the last documented value
    -- primarily used to subselect o2 flows
    , ROW_NUMBER() OVER (PARTITION BY stay_id, charttime, itemid ORDER BY storetime DESC) as rn
  FROM ce_stg1 ce
)
, o2 AS
(
    -- -- The below ITEMID can have multiple entires for charttime/storetime
    -- -- These are totally valid entries.
    --   224181 -- Small Volume Neb Drug #1              | Respiratory             | Text       | chartevents
    -- , 227570 -- Small Volume Neb Drug/Dose #1         | Respiratory             | Text       | chartevents
    -- , 224833 -- SBT Deferred                          | Respiratory             | Text       | chartevents
    -- , 224716 -- SBT Stopped                           | Respiratory             | Text       | chartevents
    -- , 224740 -- RSBI Deferred                         | Respiratory             | Text       | chartevents
    -- , 224829 -- Trach Tube Type                       | Respiratory             | Text       | chartevents
    -- , 226732 -- O2 Delivery Device(s)                 | Respiratory             | Text       | chartevents
    -- , 226873 -- Inspiratory Ratio                     | Respiratory             | Numeric    | chartevents
    -- , 226871 -- Expiratory Ratio                      | Respiratory             | Numeric    | chartevents
    -- maximum of 4 o2 devices on at once
    SELECT
        stay_id, charttime, itemid
        , value AS o2_device
    , ROW_NUMBER() OVER (PARTITION BY stay_id, charttime, itemid ORDER BY value DESC) as rn
    FROM `physionet-data.mimic_icu.chartevents`
    WHERE itemid = 226732 -- oxygen delivery device(s)
)
, stg AS
(
    select
      COALESCE(ce.stay_id, o2.stay_id) AS stay_id
    , COALESCE(ce.charttime, o2.charttime) AS charttime
    , COALESCE(ce.itemid, o2.itemid) AS itemid
    , ce.value
    , ce.valuenum
    , o2.o2_device
    , o2.rn
    from ce_stg2 ce
    FULL OUTER JOIN o2
      ON ce.stay_id = o2.stay_id
      AND ce.charttime = o2.charttime
      AND ce.itemid = o2.itemid
)
SELECT
    stay_id, charttime
    , MAX(CASE WHEN itemid = 223834 THEN valuenum ELSE NULL END) AS o2_flow
    , MAX(CASE WHEN itemid = 227287 THEN valuenum ELSE NULL END) AS o2_flow_additional
    -- ensure we retain all o2 devices for the patient
    , MAX(CASE WHEN itemid = 226732 AND rn = 1 THEN o2_device ELSE NULL END) AS o2_delivery_device_1
    , MAX(CASE WHEN itemid = 226732 AND rn = 2 THEN o2_device ELSE NULL END) AS o2_delivery_device_2
    , MAX(CASE WHEN itemid = 226732 AND rn = 3 THEN o2_device ELSE NULL END) AS o2_delivery_device_3
    , MAX(CASE WHEN itemid = 226732 AND rn = 4 THEN o2_device ELSE NULL END) AS o2_delivery_device_4
FROM stg
GROUP BY stay_id, charttime
ORDER BY stay_id, charttime
