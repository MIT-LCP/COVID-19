# set the project
gcloud config set project bidmc-covid-19

export TARGET_DATASET=mimic_covid_derived

# generate tables in pivoted subfolder
for d in measurement;
do
    for fn in `ls $d`;
    do
        # table name is file name minus extension
        tbl=`echo $fn | cut -d. -f1`
        # do not run bg_art until all other queries are run
        #if [[ tbl != 'bg_art' ]]; then
        echo "${d}/${fn}"
        cat ${d}/${fn} | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.${tbl}
        #fi
    done
done

# vasopressor medications also have a specific order
# cat medication/vasopressor.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.vasopressor
# cat medication/vasopressor_duration.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.vasopressor_duration

# defines stay_id and inclusion criteria for study
# tbl='vitalsign'; cat measurement/${tbl}.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.${tbl}
# cat measurement/covid.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.covid
cat cohort/cohort.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.cohort

cat hospitalstay/demographic.sql | bq query --use_legacy_sql=False --replace --destination_table=${TARGET_DATASET}.demographic
