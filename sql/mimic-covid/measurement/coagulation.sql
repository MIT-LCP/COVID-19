SELECT
    MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(stay_id) AS stay_id
  , MAX(charttime) AS charttime
  , le.spec_id
  -- convert from itemid into a meaningful column
  , MAX(CASE WHEN itemid = 51196 THEN valuenum ELSE NULL END) AS d_dimer
  , MAX(CASE WHEN itemid = 51214 THEN valuenum ELSE NULL END) AS fibrinogen
  , MAX(CASE WHEN itemid = 51297 THEN valuenum ELSE NULL END) AS thrombin
  , MAX(CASE WHEN itemid = 51237 THEN valuenum ELSE NULL END) AS inr
  , MAX(CASE WHEN itemid = 51274 THEN valuenum ELSE NULL END) AS pt
  , MAX(CASE WHEN itemid = 51275 THEN valuenum ELSE NULL END) AS ptt
FROM mimic_covid_hosp_phi.labevents le
WHERE le.itemid IN
(
    -- 51149, 52750, 52072, 52073 -- Bleeding Time, no data as of 2020/04/01
    51196, -- D-Dimer
    51214, -- Fibrinogen
    -- 51280, 52893, -- Reptilase Time, Not measured as of 2020/04/01
    -- 51281, 52161, -- Reptilase Time Control, Not measured as of 2020/04/01
    51297, -- thrombin
    51237, -- INR
    51274, -- PT
    51275 -- PTT
)
AND valuenum IS NOT NULL
GROUP BY le.spec_id
ORDER BY subject_id, charttime;
