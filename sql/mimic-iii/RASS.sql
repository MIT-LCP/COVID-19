select c.icustay_id, c.hadm_id, c.subject_id, c.charttime, c.valuenum as rass from `physionet-data.mimiciii_clinical.chartevents`  as c
left join `physionet-data.mimiciii_clinical.d_items` as d 
on d.itemid = c.itemid
where d.itemid in (SELECT itemid FROM `physionet-data.mimiciii_clinical.d_items` 
                  where lower(label) like '%richmond%' ) and 
      (value is not null or valuenum is not null or VALUEUOM is not null) and 
      icustay_id is not null
order by icustay_id, charttime