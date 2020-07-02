# set the project
# gcloud config set project bidmc-covid-19

export TARGET_DATASET=mimic_derived

# run the MIMIC-COVID queries replacing the dataset with MIMIC-IV datasets
export COVID_PATH='../mimic-covid'
export DATASET_REGEX='s/mimic_covid_(.+)/mimic_\1/g'

# generate tables in pivoted subfolder
for d in hospitalstay measurement;
do
    for fn in `ls ${COVID_PATH}/$d`;
    do
        # table name is file name minus extension
        tbl=`echo $fn | cut -d. -f1`
        # do not run bg_art until all other queries are run
        if [[ tbl != 'bg_art' ]]; then
            echo "${d}/${fn}"
            cat ${COVID_PATH}/${d}/${fn} | sed -E $DATASET_REGEX | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.${tbl}
        fi
    done
done

# vasopressor medications also have a specific order
# cat medication/vasopressor.sql | sed -E $DATASET_REGEX | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.vasopressor