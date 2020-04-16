-- This query combines vasopressors and outputs their start/stop time
-- i.e. when is the patient on *any* vasopressor
WITH vasomv as
(
  select
    stay_id, linkorderid
    , min(starttime) as starttime
    , max(endtime) as endtime
  from `physionet-data.mimic_covid.vasopressor`
  group by stay_id, linkorderid
)
, vasomv_grp as
(
  SELECT
    s1.stay_id,
    s1.starttime,
    MIN(t1.endtime) AS endtime
  FROM vasomv s1
  -- spooky action at a distance
  INNER JOIN vasomv t1
    ON  s1.stay_id = t1.stay_id
    AND s1.starttime <= t1.endtime
    AND NOT EXISTS(SELECT * FROM vasomv t2
                   WHERE t1.stay_id = t2.stay_id
                   AND t1.endtime >= t2.starttime
                   AND t1.endtime < t2.endtime)
  WHERE NOT EXISTS(SELECT * FROM vasomv s2
                   WHERE s1.stay_id = s2.stay_id
                   AND s1.starttime > s2.starttime
                   AND s1.starttime <= s2.endtime)
  GROUP BY s1.stay_id, s1.starttime
  ORDER BY s1.stay_id, s1.starttime
)
select
  stay_id, starttime, endtime
from vasomv_grp
order by stay_id, starttime;
