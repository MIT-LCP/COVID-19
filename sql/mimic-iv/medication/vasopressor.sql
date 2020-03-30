-- This query extracts dose+durations of dobutamine administration
select
  stay_id
  , orderid
  , linkorderid
  , di.label
  , starttime
  , endtime
  , rate
  , rateuom
  , amount
  , amountuom
  , ordercategoryname
FROM `physionet-data.mimic_icu.inputevents` ie
INNER JOIN `physionet-data.mimic_icu.d_items` di
  ON ie.itemid = di.itemid
WHERE ie.itemid IN
(
      221282 -- adenosine
    , 221653 -- dobutamine
    , 221662 -- dopamine
    , 221289 -- epinephrine
    , 221906 -- norepinephrine
    , 221749 -- phenylephrine
    , 222315 -- vasopressin
)
and statusdescription != 'Rewritten' -- only valid orders
ORDER BY stay_id, label, starttime;