-- begin query that extracts the data
SELECT 
    MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(stay_id) AS stay_id
  , MAX(charttime) AS charttime
  , le.spec_id
  -- convert from itemid into a meaningful column
  , MAX(CASE WHEN itemid = 50862 AND valuenum <=    10 THEN valuenum ELSE NULL END) AS albumin
  , MAX(CASE WHEN itemid = 50868 AND valuenum <= 10000 THEN valuenum ELSE NULL END) AS aniongap
  , MAX(CASE WHEN itemid = 51144 AND valuenum BETWEEN 0 AND 100 THEN valuenum ELSE NULL END) AS bands  
  , MAX(CASE WHEN itemid = 50882 AND valuenum <= 10000 THEN valuenum ELSE NULL END) AS bicarbonate
  , MAX(CASE WHEN itemid = 50885 AND valuenum <=   150 THEN valuenum ELSE NULL END) AS bilirubin
  , MAX(CASE WHEN itemid = 50902 AND valuenum <= 10000 THEN valuenum ELSE NULL END) AS chloride
  , MAX(CASE WHEN itemid = 50912 AND valuenum <=   150 THEN valuenum ELSE NULL END) AS creatinine
  , MAX(CASE WHEN itemid = 50931 AND valuenum <= 10000 THEN valuenum ELSE NULL END) AS glucose
  , MAX(CASE WHEN itemid = 51221 AND valuenum <=   100 THEN valuenum ELSE NULL END) AS hematocrit
  , MAX(CASE WHEN itemid = 51222 AND valuenum <=    50 THEN valuenum ELSE NULL END) AS hemoglobin
  , MAX(CASE WHEN itemid = 50813 AND valuenum <=    50 THEN valuenum ELSE NULL END) AS lactate
  , MAX(CASE WHEN itemid = 51265 AND valuenum <= 10000 THEN valuenum ELSE NULL END) AS platelet
  , MAX(CASE WHEN itemid = 50971 AND valuenum <=    30 THEN valuenum ELSE NULL END) AS potassium
  , MAX(CASE WHEN itemid = 51275 AND valuenum <=   150 THEN valuenum ELSE NULL END) AS ptt
  , MAX(CASE WHEN itemid = 51237 AND valuenum <=    50 THEN valuenum ELSE NULL END) AS inr
  , MAX(CASE WHEN itemid = 51274 AND valuenum <=   150 THEN valuenum ELSE NULL END) AS pt
  , MAX(CASE WHEN itemid = 50983 AND valuenum <=   200 THEN valuenum ELSE NULL END) AS sodium
  , MAX(CASE WHEN itemid = 51006 AND valuenum <=   300 THEN valuenum ELSE NULL END) AS bun
  , MAX(CASE WHEN itemid = 51301 AND valuenum <=  1000 THEN valuenum ELSE NULL END) AS wbc
FROM `physionet-data.mimic_hosp.labevents` le
WHERE le.itemid IN
(
  -- comment is: LABEL | CATEGORY | FLUID | NUMBER OF ROWS IN LABEVENTS
  50868, -- ANION GAP | CHEMISTRY | BLOOD | 769895
  50862, -- ALBUMIN | CHEMISTRY | BLOOD | 146697
  51144, -- BANDS - hematology
  50882, -- BICARBONATE | CHEMISTRY | BLOOD | 780733
  50885, -- BILIRUBIN, TOTAL | CHEMISTRY | BLOOD | 238277
  50912, -- CREATININE | CHEMISTRY | BLOOD | 797476
  50902, -- CHLORIDE | CHEMISTRY | BLOOD | 795568
  50931, -- GLUCOSE | CHEMISTRY | BLOOD | 748981
  51221, -- HEMATOCRIT | HEMATOLOGY | BLOOD | 881846
  51222, -- HEMOGLOBIN | HEMATOLOGY | BLOOD | 752523
  50813, -- LACTATE | BLOOD GAS | BLOOD | 187124
  51265, -- PLATELET COUNT | HEMATOLOGY | BLOOD | 778444
  50971, -- POTASSIUM | CHEMISTRY | BLOOD | 845825
  51275, -- PTT | HEMATOLOGY | BLOOD | 474937
  51237, -- INR(PT) | HEMATOLOGY | BLOOD | 471183
  51274, -- PT | HEMATOLOGY | BLOOD | 469090
  50983, -- SODIUM | CHEMISTRY | BLOOD | 808489
  51006, -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  51301 -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  -- note: 51300 is WBC count for the t lymphocyte subset
  -- 51300  -- WBC COUNT | HEMATOLOGY | BLOOD | 2371

  -- below blood gas measurements are *not* included in this query
  -- instead they are in pivoted_bg.sql
  -- 50806, -- CHLORIDE, WHOLE BLOOD | BLOOD GAS | BLOOD | 48187
  -- 50809, -- GLUCOSE | BLOOD GAS | BLOOD | 196734
  -- 50810, -- HEMATOCRIT, CALCULATED | BLOOD GAS | BLOOD | 89715
  -- 50811, -- HEMOGLOBIN | BLOOD GAS | BLOOD | 89712
  -- 50822, -- POTASSIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 192946
  -- 50824, -- SODIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 71503
)
AND valuenum IS NOT NULL
-- lab values cannot be 0 and cannot be negative
-- .. except anion gap.
AND (valuenum > 0 OR itemid = 50868)
GROUP BY le.spec_id
ORDER BY 1, 2, 3, 4;
