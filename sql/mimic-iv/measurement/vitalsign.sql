-- This query pivots the vital signs for the entire patient stay.
-- Vital signs include heart rate, blood pressure, respiration rate, and temperature
with ce as
(
  select ce.stay_id
    , ce.charttime
    , (case when itemid in (220045) and valuenum > 0 and valuenum < 300 then valuenum else null end) as HeartRate
    , (case when itemid in (220179,220050) and valuenum > 0 and valuenum < 400 then valuenum else null end) as SysBP
    , (case when itemid in (220180,220051) and valuenum > 0 and valuenum < 300 then valuenum else null end) as DiasBP
    , (case when itemid in (220052,220181,225312) and valuenum > 0 and valuenum < 300 then valuenum else null end) as MeanBP
    , (case when itemid in (220210,224690) and valuenum > 0 and valuenum < 70 then valuenum else null end) as RespRate
    , (case when itemid in (223761) and valuenum > 70 and valuenum < 120 then (valuenum-32)/1.8 -- converted to degC in valuenum call
               when itemid in (223762) and valuenum > 10 and valuenum < 50  then valuenum else null end) as TempC
    , (case when itemid in (220277) and valuenum > 0 and valuenum <= 100 then valuenum else null end) as SpO2
    , (case when itemid in (225664,220621,226537) and valuenum > 0 then valuenum else null end) as Glucose
  FROM `physionet-data.mimic_icu.chartevents` ce
  where ce.stay_id IS NOT NULL
  and ce.itemid in
  (
    220045, -- Heart Rate
    220179, -- Non Invasive Blood Pressure systolic
    220050, -- Arterial Blood Pressure systolic
    220180, -- Non Invasive Blood Pressure diastolic
    220051, -- Arterial Blood Pressure diastolic
    220052, -- Arterial Blood Pressure mean
    220181, -- Non Invasive Blood Pressure mean
    225312, -- ART BP mean
    220210, -- Respiratory Rate
    224690, -- Respiratory Rate (Total)
    220277, -- SPO2, peripheral
    -- GLUCOSE, both lab and fingerstick
    225664, -- Glucose finger stick
    220621, -- Glucose (serum)
    226537, -- Glucose (whole blood)
    -- TEMPERATURE
    223762, -- "Temperature Celsius"
    223761  -- "Temperature Fahrenheit"
  )
)
select
    ce.stay_id
  , ce.charttime
  , avg(HeartRate) as heartrate
  , avg(SysBP) as sysbp
  , avg(DiasBP) as diasbp
  , avg(MeanBP) as meanbp
  , avg(RespRate) as resprate
  , ROUND(AVG(TempC), 2) as tempc
  , avg(SpO2) as spo2
  , avg(Glucose) as glucose
from ce
group by ce.stay_id, ce.charttime
order by ce.stay_id, ce.charttime;
