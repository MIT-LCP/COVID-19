SELECT
    a.subject_id
  , a.hadm_id
  -- TODO: shift anchor age to admission date to get admission age
  , pt.anchor_age AS age
  , CASE WHEN pt.gender = 'F' THEN 1 ELSE 0 END AS is_female
  -- race/ethnicity
  , CASE WHEN a.ethnicity = 'WHITE' THEN 1 ELSE 0 END AS ethnicity_white
  , CASE WHEN a.ethnicity = 'BLACK/AFRICAN AMERICAN' THEN 1 ELSE 0 END AS ethnicity_black
  , CASE WHEN a.ethnicity = 'HISPANIC/LATINO' THEN 1 ELSE 0 END AS ethnicity_hispanic
  -- TODO: BMI on admission
  -- one option: 226531 in chartevents has weight - has noisy data tho
  -- pregnancy is sourced from ICU data
  , CAST(COALESCE(prg.pregnant, 0) AS INT64) AS pregnant
FROM mimic_core.admissions a
INNER JOIN mimic_core.patients pt
  ON a.subject_id = pt.subject_id
LEFT JOIN (
  SELECT hadm_id, MAX(valuenum) as pregnant
  FROM mimic_icu.chartevents
  WHERE itemid = 225082 -- Pregnant
  GROUP BY 1
) prg
  ON a.hadm_id = prg.hadm_id
ORDER BY subject_id;