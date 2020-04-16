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

Table | Content | Schema
----- | ----- | -----
pivoted_bg | Blood gas measurements | TBD.
pivoted_bg_art | Arterial blood gas measurements | TBD.
pivoted_lab | Laboratory measurements | TBD.
pivoted_o2_delivery | Information regarding supplemental oxygen delivery | TBD.
pivoted_ventilator_setting | Measurements and settings associated with non-invasive and invasive mechanical ventilation | TBD.
pivoted_vital | Nurse validated vital sign measurements | TBD.
vasopressor | Administration and dose of intravenous vasopressors | TBD.
vasopressor_duration | Duration of time for which a patient received vasopressors | TBD.
encounter | Defines a patient stay and provides demographic information | TBD.

### Detailed tables

#### Labs

##### complete_blood_count

Column | Unit of measure | Description
----- | ----- | -----
wbc | | 
rbc | | 
hgb | | 
hct | | 
mcv | | 
mch | | 
mchc | | 
rdw | | 
rdwsd | | 
platelets | | 

##### differential

Column | Unit of measure | Description
----- | ----- | -----
abs neutrophils | | 
abs lymphocytes | | 
abs monocytes | | 
abs eosonophils | | 
abs basophils | | 
immature granulocytes | | 
atyps | | 
metas | | 
nrbc | | 

##### red_cell_morphology

Column | Unit of measure | Description
----- | ----- | -----
rbc morph | |
poiklo | |
polychr | |
ovalocy | |
target | |
cshisto | |
echino | |

##### coagulation

Column | Unit of measure | Description
----- | ----- | -----
PT | |
PTT | |
INR | |
FIBRINOGEN | |
D-DIMER | |
TT | |
REPTILASE | |
BT | |

### chemistry

Column      | Unit of measure | Description
----------- | --------------- | -----------
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

Column      | Unit of measure | Description
----------- | --------------- | -----------
ALT | |
AST | |
LD/LDH | |
AlkPhos | |
TotalBili | |
Direct Bilirubin | |
Indirect Bilirubin | |
CK/CPK | |
Amylase | |

##### Cardiac Markers


Column      | Unit of measure | Description
----------- | --------------- | -----------
troponin-t | | 
troponin-i | | 
ck-mb | | 

##### Inflammation measures

Column            | Unit of measure | Description
----------------- | --------------- | -----------
procalcitonin     | |
CRP               |  |
Interleukin-6 (send out) |  |

##### hematologic

ferritin

##### Blood gases

Laboratory measures from patients with the time of blood collection and the time at which the result was available.

Column      | Unit of measure | Description
----------- | --------------- | -----------
Specimen | |
Temperature | |
so2 | |
pO2 | |
pCO2 | |
pH | |
aado2 | |
pafi | |
calTCO2 | |
Base Excess | |
hematocrit | |
hemoglobin | |
carboxyhemoglobin | |
methemoglobin | |
chloride | |
calcium | |
potassium | |
sodium | |
lactate | |
glucose | |