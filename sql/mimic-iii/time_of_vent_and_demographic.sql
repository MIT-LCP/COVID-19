SELECT v.* , w.weight , h.height,d.starttime,d.endtime,d.ventnum, d.duration_hours FROM `physionet-data.mimiciii_derived.icustay_detail`  as v
left join `physionet-data.mimiciii_derived.ventdurations` as d
on d.icustay_id = v.icustay_id
left join `physionet-data.mimiciii_derived.weightfirstday` as w
on w.icustay_id = v.icustay_id
left join `physionet-data.mimiciii_derived.heightfirstday` as h
on h.icustay_id = v.icustay_id

