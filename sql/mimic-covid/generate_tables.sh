# set the project
# gcloud config set project bidmc-covid-19

export TARGET_DATASET=mimic_covid_derived

# run the MIMIC-IV queries replacing the dataset with MIMIC-COVID datasets
export MIMICIV_PATH='../mimic-iv'
export DATASET_REGEX='s/mimic_(.+)/mimic_covid_\1/g'

# generate tables in pivoted subfolder
for d in measurement medication;
do
    for fn in `ls ${MIMICIV_PATH}/$d`;
    do
        # table name is file name minus extension
        tbl=`echo $fn | cut -d. -f1`
        # do not run bg_art until all other queries are run
        if [[ tbl != 'bg_art' ]]; then
            echo "${d}/${fn}"
            cat ${MIMICIV_PATH}/${d}/${fn} | sed -E $DATASET_REGEX | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.${tbl}
        fi
    done
done

# vasopressor medications also have a specific order
# cat medication/vasopressor.sql | sed -E $DATASET_REGEX | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.vasopressor