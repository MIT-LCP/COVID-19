with co_stg as
(
  select icustay_id, hadm_id
  , DATETIME_TRUNC( intime, hour) as intime
  , outtime
  , generate_array
  (
    1    , CEIL(DATETIME_DIFF(outtime, intime, HOUR))
  ) as hr
  FROM `physionet-data.mimiciii_clinical.icustays` ie
  inner join `physionet-data.mimiciii_clinical.patients` pt
    on ie.subject_id = pt.subject_id
  -- filter to adults by removing admissions with DOB ~= admission time
  where ie.intime > (DATETIME_ADD(pt.dob, INTERVAL 1 YEAR))
)
-- add in the charttime column
, co as
(
  select icustay_id, hadm_id, intime, outtime
  , DATETIME_ADD(intime, INTERVAL CAST(hr_flat AS INT64)-1 HOUR) as starttime
  , DATETIME_ADD(intime, INTERVAL CAST(hr_flat AS INT64) HOUR)   as endtime
  , CAST(hr_flat AS INT64) as hour
  from co_stg
  CROSS JOIN UNNEST(co_stg.hr) AS hr_flat
)select * from co
order by icustay_id , hour
