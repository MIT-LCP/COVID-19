-- The aim of this query is to pivot entries related to blood gases
-- which were found in LABEVENTS
select 
  -- spec_id only ever has 1 measurement for each itemid
  -- so, we may simply collapse rows using MAX()
    MAX(mrn) AS mrn
  , MAX(subject_id) AS subject_id
  , MAX(hadm_id) AS hadm_id
  , MAX(stay_id) AS stay_id
  , MAX(charttime) AS charttime
  -- spec_id *may* have different storetimes, so this is taking the latest
  , MAX(storetime) AS storetime
  , le.spec_id
  , MAX(CASE WHEN itemid = 52025 THEN value ELSE NULL END) AS specimen
  , MAX(CASE WHEN itemid = 50801 THEN valuenum ELSE NULL END) AS aado2
  , MAX(CASE WHEN itemid = 50802 THEN valuenum ELSE NULL END) AS baseexcess
  , MAX(CASE WHEN itemid = 50803 THEN valuenum ELSE NULL END) AS bicarbonate
  , MAX(CASE WHEN itemid = 50804 THEN valuenum ELSE NULL END) AS totalco2
  , MAX(CASE WHEN itemid = 50805 THEN valuenum ELSE NULL END) AS carboxyhemoglobin
  , MAX(CASE WHEN itemid = 50806 THEN valuenum ELSE NULL END) AS chloride
  , MAX(CASE WHEN itemid = 50808 THEN valuenum ELSE NULL END) AS calcium
  , MAX(CASE WHEN itemid = 50809 THEN valuenum ELSE NULL END) AS glucose
  , MAX(CASE WHEN itemid = 50810 and valuenum <= 100 THEN valuenum ELSE NULL END) AS hematocrit
  , MAX(CASE WHEN itemid = 50811 THEN valuenum ELSE NULL END) AS hemoglobin
  , MAX(CASE WHEN itemid = 50813 THEN valuenum ELSE NULL END) AS lactate
  , MAX(CASE WHEN itemid = 50814 THEN valuenum ELSE NULL END) AS methemoglobin
  , MAX(CASE WHEN itemid = 50815 THEN valuenum ELSE NULL END) AS o2flow
  -- fix a common unit conversion error for fio2
  -- atmospheric o2 is 20.89%, so any value <= 20 is unphysiologic
  -- usually this is a misplaced O2 flow measurement
  , MAX(CASE WHEN itemid = 50816 THEN
      CASE
        WHEN valuenum > 20 AND valuenum <= 100 THEN valuenum 
        WHEN valuenum > 0.2 AND valuenum <= 1.0 THEN valuenum*100.0
      ELSE NULL END
    ELSE NULL END) AS fio2
  , MAX(CASE WHEN itemid = 50817 AND valuenum <= 100 THEN valuenum ELSE NULL END) AS so2
  , MAX(CASE WHEN itemid = 50818 THEN valuenum ELSE NULL END) AS pco2
  , MAX(CASE WHEN itemid = 50819 THEN valuenum ELSE NULL END) AS peep
  , MAX(CASE WHEN itemid = 50820 THEN valuenum ELSE NULL END) AS ph
  , MAX(CASE WHEN itemid = 50821 THEN valuenum ELSE NULL END) AS po2
  , MAX(CASE WHEN itemid = 50822 THEN valuenum ELSE NULL END) AS potassium
  , MAX(CASE WHEN itemid = 50823 THEN valuenum ELSE NULL END) AS requiredo2
  , MAX(CASE WHEN itemid = 50824 THEN valuenum ELSE NULL END) AS sodium
  , MAX(CASE WHEN itemid = 50825 THEN valuenum ELSE NULL END) AS temperature
  , MAX(CASE WHEN itemid = 50807 THEN value ELSE NULL END) AS comments
FROM mimic_covid_hosp_phi.labevents le
where le.ITEMID in
-- blood gases
(
    52025 -- specimen
  , 50801 -- aado2
  , 50802 -- base excess
  , 50803 -- bicarb
  , 50804 -- calc tot co2
  , 50805 -- carboxyhgb
  , 50806 -- chloride
  -- , 52390 -- chloride, WB CL-
  , 50807 -- comments
  , 50808 -- free calcium
  , 50809 -- glucose
  , 50810 -- hct
  , 50811 -- hgb
  , 50813 -- lactate
  , 50814 -- methemoglobin
  , 50815 -- o2 flow
  , 50816 -- fio2
  , 50817 -- o2 sat
  , 50818 -- pco2
  , 50819 -- peep
  , 50820 -- pH
  , 50821 -- pO2
  , 50822 -- potassium
  -- , 52408 -- potassium, WB K+
  , 50823 -- required O2
  , 50824 -- sodium
  -- , 52411 -- sodium, WB NA +
  , 50825 -- temperature
)
GROUP BY le.spec_id
ORDER BY 1, 2, 3, 4;