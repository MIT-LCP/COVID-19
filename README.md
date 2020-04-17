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

Table | Content | Schema
----- | ----- | -----
bg | Blood gas measurements | TBD.
bg_art | Arterial blood gas measurements | TBD.
lab | Laboratory measurements | TBD.
o2_delivery | Information regarding supplemental oxygen delivery | TBD.
ventilator_setting | Measurements and settings associated with non-invasive and invasive mechanical ventilation | TBD.
vitalsign | Nurse validated vital sign measurements | TBD.
vasopressor | Administration and dose of intravenous vasopressors | TBD.
vasopressor_duration | Duration of time for which a patient received vasopressors | TBD.
encounter | Defines a patient stay and provides demographic information | TBD.

### Detailed tables

#### Labs

##### complete_blood_count

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
wbc           | Numeric    |                 | 
rbc           | Numeric    |                 | 
hgb           | Numeric    |                 | 
hct           | Numeric    |                 | 
mcv           | Numeric    |                 | 
mch           | Numeric    |                 | 
mchc          | Numeric    |                 | 
rdw           | Numeric    |                 | 
rdwsd         | Numeric    |                 | 
platelets     | Numeric    |                 | 

##### differential

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
abs neutrophils       | Numeric    |                 | 
abs lymphocytes       | Numeric    |                 | 
abs monocytes         | Numeric    |                 | 
abs eosonophils       | Numeric    |                 | 
abs basophils         | Numeric    |                 | 
immature granulocytes | Numeric    |                 | 
atyps                 | Numeric    |                 | 
metas                 | Numeric    |                 | 
nrbc                  | Numeric    |                 | 

##### red_cell_morphology

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
rbc morph       | Numeric    |                 | 
poiklo       | Numeric    |                 | 
polychr       | Numeric    |                 | 
ovalocy       | Numeric    |                 | 
target       | Numeric    |                 | 
cshisto       | Numeric    |                 | 
echino       | Numeric    |                 | 

##### coagulation

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
PT       | Numeric    |                 | 
PTT       | Numeric    |                 | 
INR       | Numeric    |                 | 
FIBRINOGEN       | Numeric    |                 | 
D-DIMER       | Numeric    |                 | 
TT       | Numeric    |                 | 
REPTILASE       | Numeric    |                 | 
BT       | Numeric    |                 | 

### chemistry

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
Albumin |
Globulin |
Total Protein | 
Calcium |
creatinine  | 
glucose     | 
bun         | 
sodium      | 
potassium   | 
chloride    | 
bicarbonate | 
aniongap    | 

##### Liver enzymes

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
ALT       | Numeric    |                 | 
AST       | Numeric    |                 | 
LD/LDH       | Numeric    |                 | 
AlkPhos       | Numeric    |                 | 
TotalBili       | Numeric    |                 | 
Direct Bilirubin       | Numeric    |                 | 
Indirect Bilirubin       | Numeric    |                 | 
CK/CPK       | Numeric    |                 | 
Amylase       | Numeric    |                 | 

##### Cardiac Markers

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
troponin-t       | Numeric    |                 |  
troponin-i       | Numeric    |                 |  
ck-mb       | Numeric    |                 |  

##### Inflammation measures

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
procalcitonin           | Numeric    |                 | 
CRP               |  |
Interleukin-6 (send out) |  |

##### hematologic

ferritin

##### Blood gases

Laboratory measures from patients with the time of blood collection and the time at which the result was available.

Column        | Data type  | Unit of measure | Description
------------- | ---------- | --------------- | -----------
subject_id    | Integer    | N/A             | Patient identifier.
charttime     | Timestamp  | N/A             | Time at which the specimen was drawn from the patient.
specimen_id   | Integer    | N/A             | Unique identifier for the specimen drawn from the patient which the measurements are derived from.
specimen_type | Text       |                 | 
Temperature       | Numeric    |                 | 
so2       | Numeric    |                 | 
pO2       | Numeric    |                 | 
pCO2       | Numeric    |                 | 
pH       | Numeric    |                 | 
aado2       | Numeric    |                 | 
pafi       | Numeric    |                 | 
calTCO2       | Numeric    |                 | 
Base Excess       | Numeric    |                 | 
hematocrit       | Numeric    |                 | 
hemoglobin       | Numeric    |                 | 
carboxyhemoglobin       | Numeric    |                 | 
methemoglobin       | Numeric    |                 | 
chloride       | Numeric    |                 | 
calcium       | Numeric    |                 | 
potassium       | Numeric    |                 | 
sodium       | Numeric    |                 | 
lactate       | Numeric    |                 | 
glucose       | Numeric    |                 | 