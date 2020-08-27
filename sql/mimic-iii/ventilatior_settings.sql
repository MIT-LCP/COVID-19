select
  icustay_id, charttime
  -- case statement determining whether it is an instance of mech vent
  ,max(case when itemid = 223848 then value else null end) as VentTypeRecorded
  ,max(case when itemid = 223849 then value else null end) as ventilatormode
  ,max(case when itemid = 220339 then valuenum else null end) as peep_set -- PEEP
  ,max(case when itemid = 224700 then valuenum else null end ) as Total_PEEP_level 
  ,max(case when itemid = 224684 then valuenum else null end ) as Tidal_Volume_set
  ,max(case when itemid = 224685 then valuenum else null end ) as Tidal_Volume_observed
  ,max(case when itemid = 224686 then valuenum else null end ) as Tidal_Volume_spontaneous
, max(case when itemid =  224687 then value else null end) as minutes_vol 
  ,max(case when itemid = 224688 then valuenum else null end ) as RR_set_Set
  ,max(case when itemid = 224689 then valuenum else null end ) as RR_set_Set_spontaneous
  ,max(case when itemid = 224690 then valuenum else null end ) as RR_set_Set_total
  , max (case when itemid = 224695 then value else null end ) as Peak_Insp_Pressure
  , max (case when itemid = 224696 then value else null end ) as Plateau_Pressure
  , max (case when itemid = 224697 then value else null end ) as mean_airway_Pressure
  , max(case
        -- initiation of oxygen therapy indicates the ventilation has ended
        when (itemid = 226732 and value in
        (
          'Nasal cannula', -- 153714 observations
          'Face tent', -- 24601 observations
          'Aerosol-cool', -- 24560 observations
          'Trach mask ', -- 16435 observations
          'High flow neb', -- 10785 observations
          'Non-rebreather', -- 5182 observations
          'Venti mask ', -- 1947 observations
          'Medium conc mask ', -- 1888 observations
          'T-piece', -- 1135 observations
          'High flow nasal cannula', -- 925 observations
          'Ultrasonic neb', -- 9 observations
          'Vapomist' -- 3 observations
        )) then value else null end )as O2_Delivery_Device
      , max(case when itemid =  227287 then value else null end) as O2_Flow_additional_cannula
      , max (case when itemid = 223834 then value else null end ) as o2_flow       
      , max (case when itemid = 224746 then value else null end ) as Transpulmonary_Press_Exp_Hold
      , max (case when itemid = 224747 then value else null end ) as Transpulmonary_Press_Insp_Hold
      , max (case when itemid = 226873 then value else null end ) as Inspiratory_Ratio
      , max (case when itemid = 224419 then value else null end ) as Negative_Insp_Force
      , max (case when itemid = 224738 then value else null end ) as Inspiratory_Time
      , max (case when itemid = 224750 then value else null end ) as Nitric_Oxide_Tank_Pressure
      , max (case when itemid = 227187 then value else null end ) as Pinsp_Draeger_only
      , max (case when itemid = 224701 then value else null end ) as PSVlevel
      , max (case when itemid = 224702 then value else null end ) as PCV_Level_Avea
      , max (case when itemid = 224705 then value else null end ) as P_High_APRV
      , max (case when itemid = 224706 then value else null end ) as P_Low_APRV
      , max (case when itemid = 224707 then value else null end ) as T_High_APRV
      , max (case when itemid = 224709 then value else null end ) as T_Low_APRV
      , max (case when itemid = 229393 then value else null end ) as PF_Ratio
      , max (case when itemid = 229394 then value else null end ) as SF_Ratio
      ------BIPAP related
      , max (case when itemid = 227577 then value else null end ) as BiPap_Mode
      , max (case when itemid = 227578 then value else null end ) as BiPap_Mask
      , max (case when itemid = 227579 then value else null end ) as BiPap_EPAP
      , max (case when itemid = 227580 then value else null end ) as BiPap_IPAP      
      

from `physionet-data.mimiciii_clinical.chartevents` ce
where ce.value is not null
and icustay_id is not null
-- exclude rows marked as error
and (ce.error != 1 or ce.error IS NULL)
group by icustay_id, charttime
order by icustay_id, charttime


#UNION DISTINCT
#-- add in the extubation flags from procedureevents_mv
#-- note that we only need the start time for the extubation
#-- (extubation is always charted as ending 1 minute after it started)
#select
#  icustay_id, starttime as charttime
#  , 0 as MechVent
#  , 0 as OxygenTherapy
#  , 1 as Extubated
#  , case when itemid = 225468 then 1 else 0 end as SelfExtubated
#from `physionet-data.mimiciii_clinical.procedureevents_mv`
#where itemid in
#(
#  227194 -- "Extubation"
#, 225468 -- "Unplanned Extubation (patient-initiated)"
#, 225477 -- "Unplanned Extubation (non-patient initiated)"
#);

