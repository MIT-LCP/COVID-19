SELECT
  stay_id
  , i.intime
  , i.outtime
  , CASE
        WHEN pt.anchor_age = '10 - 20' THEN 15
        WHEN pt.anchor_age = '20 - 30' THEN 25
        WHEN pt.anchor_age = '30 - 40' THEN 25
        WHEN pt.anchor_age = '40 - 50' THEN 45
        WHEN pt.anchor_age = '50 - 60' THEN 55
        WHEN pt.anchor_age = '60 - 70' THEN 65
        WHEN pt.anchor_age = '70 - 80' THEN 75
        WHEN pt.anchor_age = '> 80' THEN 90
    END as age
  , pt.gender as genotypical_sex
  -- TODO: BMI on admission
  -- pregnancy
  , a.hospital_expire_flag
FROM `physionet-data.mimic_icu.icustays` i
INNER JOIN `physionet-data.mimic_core.admissions` a
  ON i.hadm_id = a.hadm_id
INNER JOIN `physionet-data.mimic_core.patients` pt
  ON i.subject_id = pt.subject_id
ORDER BY stay_id;