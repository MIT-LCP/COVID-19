-- begin query that extracts the data
SELECT
    MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(charttime) AS charttime
  , le.spec_id
  -- the case statement for covid_status misses ~20 labs
  -- these have conflicting cov2/cov4 reports (usually cov2 is correct)
  -- other rows have cov5
  -- can impute as needed
  , MAX(CASE WHEN itemid = 51845 THEN
        CASE
        WHEN STARTS_WITH(comments, "NEG") THEN "NEGATIVE"
        WHEN STARTS_WITH(comments, "POS") THEN "POSITIVE"
        WHEN STARTS_WITH(comments, "VOID") THEN "ERROR"
        WHEN STARTS_WITH(comments, "z1O") THEN "ERROR"
        WHEN STARTS_WITH(comments, "UNINTERPRETABLE") THEN "ERROR"
        WHEN STARTS_WITH(comments, "x9B8") THEN "ERROR"
        WHEN STARTS_WITH(comments, "Q-") THEN "ERROR"
        WHEN storetime IS NULL THEN 'PENDING'
        WHEN comments IS NULL THEN 'PENDING'
    END ELSE NULL END) AS covid_status
  , MAX(CASE WHEN itemid = 51841 THEN COALESCE(comments, value) ELSE NULL END) AS cov1
  , MAX(CASE WHEN itemid = 51900 THEN COALESCE(comments, value) ELSE NULL END) AS cov2
  , MAX(CASE WHEN itemid = 51842 THEN COALESCE(comments, value) ELSE NULL END) AS cov3
  , MAX(CASE WHEN itemid = 51901 THEN COALESCE(comments, value) ELSE NULL END) AS cov4
  , MAX(CASE WHEN itemid = 51843 THEN COALESCE(comments, value) ELSE NULL END) AS cov5
  , MAX(CASE WHEN itemid = 51844 THEN COALESCE(comments, value) ELSE NULL END) AS cov6
  , MAX(CASE WHEN itemid = 51845 THEN COALESCE(comments, value) ELSE NULL END) AS covid19
FROM mimic_covid_hosp_phi.labevents le
WHERE le.itemid IN
(
51841, -- COV1
51900, -- COV2
51842, -- COV3
51901, -- COV4
51843, -- COV5
51844, -- COV6
51845  -- COVID-19
)
GROUP BY le.spec_id
ORDER BY charttime;
