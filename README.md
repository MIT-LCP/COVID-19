# COVID-19

Analysis of high resolution clinical data for COVID-19 patients could significantly impact guidelines around optimal treatment.
Due to significant administrative challenges in sharing de-identified clinical data, we have created a repository for performing federated analysis of COVID-19 patients.
The idea is simple: reformat your data into our proposed 10-15 views, and you'll be able to leverage all analysis code in this repository.
We are actively seeking collaborators to expand the scope of the analysis to more patients!

## Organization

The organization is as follows:

* [sql](/sql) - The SQL folder has local scripts for each dataset which convert.
  * [mimic-iii][/sql/mimic-iii] - MIMIC-III is a publicly accessible critical care database. Though MIMIC-III does not contain information on patients with COVID-19, its highly accessible nature makes it useful for prototyping. The [MIMIC-III Clinical Database Demo](https://physionet.org/content/mimiciii-demo/1.4/) is openly available and can be used to better understand the queries and ultimate data structure.
  * [mimic-iv](/sql/mimic-iv) - MIMIC-IV is a non-public update to MIMIC-III which contains more recent information.
* [data](/data) - A placeholder folder to contain harmonized datasets. Analysis code assumes data is present in this folder.
* [notebooks](/notebooks) - Jupyter notebooks which contain end-to-end analyses of COVID-19 data.
