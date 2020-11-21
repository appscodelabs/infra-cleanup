#!/bin/bash

PROJECT=appscode-testing

for entry in $(gcloud container clusters list --project=$PROJECT --format='csv[no-heading](name,zone)'); do
    IFS=','                                                                            # , is set as delimiter
    read -ra PARTS <<<"$entry"                                                         # str is read into an array as tokens separated by IFS
    # echo ${PARTS[0]}
    # echo ${PARTS[1]}
    gcloud container clusters delete --project=$PROJECT --zone=${PARTS[1]} ${PARTS[0]} # --async
done

# for name in $(gcloud container clusters list --project=$PROJECT --format='value(name)'); do
#     gcloud container clusters delete --project=$PROJECT $name # --async
# done

# for name in $(gcloud compute disks list --project=$PROJECT --format='value(name)'); do
#     gcloud compute disks delete --project=$PROJECT $name
# done
