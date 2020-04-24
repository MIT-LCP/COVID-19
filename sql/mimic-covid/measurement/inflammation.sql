SELECT
    MAX(mrn) AS mrn
  , MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(stay_id) AS stay_id
  , MAX(charttime) AS charttime
  , le.spec_id
  -- convert from itemid into a meaningful column
  , MAX(CASE WHEN itemid = 50889 THEN valuenum ELSE NULL END) AS crp
  , MAX(CASE WHEN itemid = 51652 THEN valuenum ELSE NULL END) AS crp_high_sens
  , CAST(NULL AS NUMERIC) AS il6
  , CAST(NULL AS NUMERIC) AS procalcitonin
FROM mimic_covid_hosp_phi.labevents le
WHERE le.itemid IN
(
    50889, -- crp
    51652 -- high sensitivity CRP
)
AND valuenum IS NOT NULL
-- lab values cannot be 0 and cannot be negative
AND valuenum > 0
GROUP BY le.spec_id
ORDER BY mrn, charttime;