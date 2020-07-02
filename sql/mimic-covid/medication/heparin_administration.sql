SELECT
  e.subject_id
  , e.charttime
  , e.event_txt
  , e.storetime
  -- debug columns
  , e.emar_id
  , e.emar_seq
  , e.medication
  , e.poe_id
  -- , e.pharmacy_id
  , det.administration_types
  , det.dose_due
  , det.dose_due_unit
  , det.complete_dose_not_given
  , det.will_remainder_of_dose_be_given
  -- grouped administration info
  , dgrp.dose_given
  , dgrp.dose_given_unit
  , dgrp.dose_given_string
  , dgrp.product_amount_given
  , dgrp.product_unit
FROM mimic_covid_hosp.emar e
-- dose due is in the "parent" of the emar detail group
-- where parent_field_ordinal is null
-- only 1 of these per emar
LEFT JOIN mimic_covid_hosp.emar_detail det
  ON e.emar_id = det.emar_id
  AND det.parent_field_ordinal IS NULL
-- group together individual administrations to get total administered
-- since dose is sometimes a string, include a string concat for debug purposes
LEFT JOIN (
  SELECT emar_id
  , SUM(CASE
           WHEN REGEXP_CONTAINS(dose_given, r'^[0-9]*\.?[0-9]*$')
             THEN CAST(dose_given AS NUMERIC)
        ELSE NULL END) AS dose_given
  , STRING_AGG(dose_given) AS dose_given_string
  , MAX(dose_given_unit) AS dose_given_unit
  , SUM(CASE
           WHEN REGEXP_CONTAINS(product_amount_given, r'^[0-9]*\.?[0-9]*$')
             THEN CAST(product_amount_given AS NUMERIC)
        ELSE NULL END) AS product_amount_given
  , STRING_AGG(product_amount_given) AS product_amount_given_string
  , MAX(product_unit) AS product_unit
  FROM mimic_covid_hosp.emar_detail
  GROUP BY emar_id
) dgrp
  ON e.emar_id = dgrp.emar_id
WHERE e.medication IN
(
  'Heparin',
  -- 'Heparin (CRRT Machine Priming)',
  -- 'Heparin CRRT',
  -- 'Heparin (Hemodialysis)',
  -- 'Heparin (IABP)',
  -- 'Heparin (Impella) – Left ventricle',
  -- 'Heparin (Impella) – Right ventricle',
  -- 'Heparin LVAD',
  'Heparin (via Anti-Xa Monitoring)',
  'Heparin Desensitization'
  -- 'Heparin Dwell (1000 Units/mL)',
  -- 'Heparin Flush (1 unit/mL)',
  -- 'Heparin Flush (10 units/mL)',
  -- 'Heparin Flush (10 units/ml)',
  -- 'Heparin Flush (100 units/ml)',
  -- 'Heparin Flush (1000 units/mL)',
  -- 'Heparin INTRAPERITONEAL'
)
ORDER BY subject_id, e.emar_seq, parent_field_ordinal
