# COVID-19

Analysis of high resolution clinical data for COVID-19 patients could significantly impact guidelines around optimal treatment.
Due to significant administrative challenges in sharing de-identified clinical data, we have created a repository for performing federated analysis of COVID-19 patients.
The idea is simple: reformat your data into our proposed 10-15 views, and you'll be able to leverage all analysis code in this repository.
We are actively seeking collaborators to expand the scope of the analysis to more patients!

## Organization

The organization is as follows:

* [sql](/sql) - The SQL folder has local scripts for each dataset which convert.
  * [mimic-iii](/sql/mimic-iii) - MIMIC-III is a publicly accessible critical care database. Though MIMIC-III does not contain information on patients with COVID-19, its highly accessible nature makes it useful for prototyping. The [MIMIC-III Clinical Database Demo](https://physionet.org/content/mimiciii-demo/1.4/) is openly available and can be used to better understand the queries and ultimate data structure.
  * [mimic-iv](/sql/mimic-iv) - MIMIC-IV is a non-public update to MIMIC-III which contains more recent information.
* [data](/data) - A placeholder folder to contain harmonized datasets. Analysis code assumes data is present in this folder.
* [notebooks](/notebooks) - Jupyter notebooks which contain end-to-end analyses of COVID-19 data.

## Table structure

In order to facilitate shared analysis, we have defined a common set of views/tables.

**The table structure is a work in progress.**

Table | Content
----- | -----
[cohort](#cohort) |  Defines `stay_id`, a single ICU stay.
[GCS](#gcs) | Glasgow coma scale measures.
[RASS](#rass) | Richmond Sedation Agitation Scale measurements
[oxygen_delivery](#oxygen-delivery) | Information regarding supplemental oxygen delivery
[ventilator_setting](#ventilator-setting) | Measurements and settings associated with non-invasive and invasive mechanical ventilation
[vitalsign](#vitalsign) | Nurse validated vital sign measurements
[vasopressor](#vasopressor) | Administration and dose of intravenous vasopressors
[bg](#blood-gases) | Blood gas measurements
[cbc](#complete_blood_count) | Counts of the number of blood cells and related measures.
[differential](#differential) | Detailed differential counts of white blood cells
[red cell morphology](#red_cell_morphology) | Morphology of red blood cells
[coagulation](#coagulation) | Measures of blood coagulation
[chemistry](#chemistry) | Electrolyte and protein counts
[enzymes](#enzymes-and-bilirubin) | Enzymes concentrations and bilirubin concentration
[cardiac_markers](#cardiac-markers) | Markers of cardiac function or injury
[inflammation_measures](#inflammation-measures) | Measures of inflammation

### Detailed tables

#### Cohort

Must create a `stay_id`, `intime`, `outtime` triplet to assign a unique stay in the ICU for each patient. `subject_id` should uniquely define the patient.

#### Charted data

##### GCS

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
stay_id       | Integer    | N/A             | Encounter identifier.
charttime     | Timestamp  | N/A             | Time at which the charted event was valid.
gcs           | Integer    | N/A             | Glasgow coma scale.
gcs_motor     | Integer    | N/A             |
gcs_verbal    | Integer    | N/A             |
gcs_eyes      | Integer    | N/A             |
gcs_unable    | Integer    | N/A             | Unable to assess GCS due to sedation/intubation.

##### RASS

Column        | Data type | Unit of measure | Description
------------- | --------- | --------------- | -----------
subject_id    | Integer   | N/A             | Patient identifier.
stay_id       | Integer   | N/A             | Encounter identifier.
charttime     | Timestamp | N/A             | Time at which the charted event was valid.
rass          | Integer   | N/A             | Current Richmond Agitation Sedation Scale value
rass_target   | Integer   | N/A             | Desired Richmond Agitation Sedation Scale value

##### Oxygen Delivery

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
stay_id       | Integer    | N/A             | Encounter identifier.
charttime     | Timestamp  | N/A             | Time at which the charted event was valid.
o2_flow       | Numeric    | Litres/minute   | Oxygen flow provided to the patient.
o2_flow_additional | Numeric    | Litres/minute   | Additional oxygen flow provided by one or more secondary devices.
o2_delivery_device_1       | Numeric    | Litres/minute   | Primary oxygen delivery device.
o2_delivery_device_2       | Numeric    | Litres/minute   | Secondary oxygen delivery device.
o2_delivery_device_3       | Numeric    | Litres/minute   | Tertiary oxygen delivery device.
o2_delivery_device_4       | Numeric    | Litres/minute   | Quartenary oxygen delivery device.

##### Ventilator Setting

Column                        | Data type   | Unit of measure | Description
-------------------------     | ----------  | --------------- | -----------
subject_id                    | Integer     | N/A             | Patient identifier.
stay_id                       | Integer     | N/A             | Encounter identifier.
charttime                     | Timestamp   | N/A             | Time at which the charted event was valid.
respiratory_rate_set          | Numeric     | Breaths/min     | Breathing rate set by the ventilator
respiratory_rate_spontaneous  | Numeric     | Breaths/min     | Breathing rate occuring above the set rate
respiratory_rate_total        | Numeric     | Breaths/min     | Actual breathing rate
minute_volume                 | Numeric     | L/min           | Litres of air inspired per minute
tidal_volume_set              | Numeric     | mL              | Tidal volume set by the ventilator
tidal_volume_observed         | Numeric     | mL              | Observed tidal volume
tidal_volume_spontaneous      | Numeric     | mL              | Tidal volume of spontaneous breaths over the ventilator
plateau_pressure              | Numeric     | cm H2O          | Maximum pressure observed in the lungs
peep                          | Numeric     | cm H2O          | Positive end expiratory pressure
fio2                          | Numeric     | Proportion      | Fraction of inspired oxygen in the air
ventilator_mode               | String      | N/A             | Mode of ventilation (assist control, etc)
ventilator_mode_hamilton      | String      | N/A             | Special mode settings for Hamilton brand ventilators
ventilator_type               | String      | N/A             | Type of ventilator used

#### Labs

##### Blood gases

Laboratory measures from patients with the time of blood collection and the time at which the result was available.

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
Temperature   | Numeric    |                 | 
so2           | Numeric    |                 | 
pO2           | Numeric    |                 | 
pCO2          | Numeric    |                 | 
pH            | Numeric    |                 | 
aado2         | Numeric    |                 | 
pafi          | Numeric    |                 | 
calTCO2       | Numeric    |                 | 
Base Excess   | Numeric    |                 | 
hematocrit    | Numeric    |                 | 
hemoglobin    | Numeric    |                 | 
carboxyhemoglobin       | Numeric    |                 | 
methemoglobin | Numeric    |                 | 
chloride      | Numeric    |                 | 
calcium       | Numeric    |                 | 
potassium     | Numeric    |                 | 
sodium        | Numeric    |                 | 
lactate       | Numeric    |                 | 
glucose       | Numeric    |                 | 

##### complete_blood_count

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
hct           | Numeric    | %               | Hematocrit
hgb           | Numeric    | g/dL            | Hemoglobin
mch           | Numeric    | pg              | Mean corpuscular hemoglobin
mchc          | Numeric    | g/dL            | Mean corpuscular hemoglobin concentration
mcv           | Numeric    | fL              | Mean corpuscular volume
platelets     | Numeric    | K/uL            | Platelet count
rbc           | Numeric    | m/uL            | Red blood cells
rdw           | Numeric    | %               | Red blood cell distribution width
rdwsd         | Numeric    | fL              | Red blood cell distribution width standard deviation
wbc           | Numeric    | K/uL            | White blood cell count

##### differential

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
abs_basophils         | Numeric    | K/uL            | Absolute Basophil Count
abs_eosinophils       | Numeric    | K/uL            | Absolute Eosinophil Count
abs_lymphocytes       | Numeric    | K/uL            | Absolute Lymphocyte Count
abs_monocytes         | Numeric    | K/uL            | Absolute Monocyte Count
abs_neutrophils       | Numeric    | K/uL            | Absolute Neutrophil Count
atyps                 | Numeric    | %               | Atypical Lymphocytes
bands                 | Numeric    | %               | Immature Band Forms
imm_granulocytes      | Numeric    | %               | Immature Granulocytes
metas                 | Numeric    | %               | Metamyelocytes
nrbc                  | Numeric    | %               | Nucleated Red Blood Cells

##### red_cell_morphology

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
rbc morph     | Numeric    |                 | 
poiklo        | Numeric    |                 | 
polychr       | Numeric    |                 | 
ovalocy       | Numeric    |                 | 
target        | Numeric    |                 | 
cshisto       | Numeric    |                 | 
echino        | Numeric    |                 | 

##### coagulation

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
d_dimer       | Numeric    | ng/mL FEU       | D-Dimer
fibrinogen    | Numeric    | mg/dL           | Fibrinogen, Functional
thrombin      | Numeric    | sec             | Thrombin Time
inr           | Numeric    | N/A (ratio)     | International Normalized Ratio
pt            | Numeric    | sec             | Prothrombin Time
ptt           | Numeric    | sec             | Partial Thromboplastin Time

##### chemistry

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
Albumin       | Numeric    | g/dL            |
Globulin      | Numeric    | g/dL            |
total_protein | Numeric    | g/dL            |
aniongap      | Numeric    | mEq/L           |
bicarbonate   | Numeric    | mEq/L           |
bun           | Numeric    | mg/dL           |
calcium       | Numeric    | mg/dL           |
chloride      | Numeric    | mEq/L           |
creatinine    | Numeric    | mg/dL           |
glucose       | Numeric    | mg/dL           |
sodium        | Numeric    | mEq/L           |
potassium     | Numeric    | mEq/L           |

##### Enzymes (and Bilirubin)

Column              | Data type  | Unit of measure | Description
-------------       | ---------- | --------------- | -----------
subject_id          | Integer    | N/A             | Patient identifier.
charttime           | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id         | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
alt                 | Numeric    |                 | Alanine Aminotransferase
alkphos             | Numeric    |                 | Alkaline Phosphatase
ast                 | Numeric    |                 | Asparate Aminotransferase
amylase             | Numeric    |                 | Amylase
bilirubin_total     | Numeric    |                 | Total Bilirubin (direct + indirect)
bilirubin_direct    | Numeric    |                 | Direct Bilirubin
bilirubin_indirect  | Numeric    |                 | Indirect Bilirubin
ck_cpk              | Numeric    |                 | Creatinine Kinase
ld_ldh              | Numeric    |                 | Lactate Dehydronase.

##### Cardiac Markers

Column          | Data type  | Unit of measure | Description
--------------- | ---------- | --------------- | -----------
subject_id      | Integer    | N/A             | Patient identifier.
charttime       | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id     | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
troponin_i      | Numeric    |                 | Troponin I
troponin_i_poc  | Numeric    |                 | Troponin I, Point of Care test
troponin_t      | Numeric    |                 | Tropinin T
ck_mb           | Numeric    |                 | Creatinine Kinase, MB Isoenzyme

##### Inflammation measures

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
crp           | Numeric    |                 | C-reactive Protein
crp_high_sens | Numeric    |                 | C-reactive Protein, high sensitivity assay
il6           | Numeric    |                 | Interleukin-6 (send out)
procalcitonin | Numeric    |                 | Procalcitonin

##### hematologic/other

* ferritin
* ggt
* transaminase
* 5ntd
* ceruloplasmin
* alpha-fetoprotein
