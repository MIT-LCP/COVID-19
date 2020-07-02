-- begin query that extracts the data
SELECT
    MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(charttime) AS charttime
  , le.specimen_id
  -- the case statement for covid_status misses ~20 labs
  -- these have conflicting cov2/cov4 reports (usually cov2 is correct)
  -- other rows have cov5
  -- can impute as needed
  , MAX(CASE WHEN itemid = 51853 AND storetime IS NULL THEN 'PENDING'
             WHEN itemid = 51853 THEN value 
             ELSE NULL
    END) AS covid_status
  , MAX(CASE WHEN itemid = 51890 AND storetime IS NULL THEN 'PENDING'
             WHEN itemid = 51890 THEN value 
             ELSE NULL
    END) AS covid_rapid
  , MAX(CASE WHEN itemid = 51849 THEN value ELSE NULL END) AS cov1
  , MAX(CASE WHEN itemid = 51908 THEN value ELSE NULL END) AS cov2
  , MAX(CASE WHEN itemid = 51850 THEN value ELSE NULL END) AS cov3
  , MAX(CASE WHEN itemid = 51909 THEN value ELSE NULL END) AS cov4
  , MAX(CASE WHEN itemid = 51851 THEN value ELSE NULL END) AS cov5
  , MAX(CASE WHEN itemid = 51852 THEN value ELSE NULL END) AS cov6
FROM mimic_covid_hosp.labevents le
WHERE le.itemid IN
(
  51849, -- COV1
  51908, -- COV2
  51850, -- COV3
  51909, -- COV4
  51851, -- COV5
  51852, -- COV6
  51853,  -- COVID-19
  51890 -- Rapid COVID
)
GROUP BY le.specimen_id
ORDER BY charttime;
