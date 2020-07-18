SELECT
    a.subject_id
  , i.stay_id
  , a.dischtime as hospital_discharge_time
  , a.hospital_expire_flag
FROM mimic_icu.icustays i
INNER JOIN mimic_core.admissions a
  ON i.hadm_id = a.hadm_id
ORDER BY subject_id, stay_id;