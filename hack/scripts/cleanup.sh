#!/bin/bash

set -eou pipefail

PROJECT=appscode-testing

for entry in $(gcloud container clusters list --project=$PROJECT --format='csv[no-heading](name,zone)'); do
    IFS=','                                                                                    # , is set as delimiter
    read -ra PARTS <<<"$entry"                                                                 # str is read into an array as tokens separated by IFS
    gcloud container clusters delete --quiet --project=$PROJECT --zone=${PARTS[1]} ${PARTS[0]} # --async
done

for entry in $(gcloud compute disks list --project=$PROJECT --format='csv[no-heading](name,zone)'); do
    IFS=','                    # , is set as delimiter
    read -ra PARTS <<<"$entry" # str is read into an array as tokens separated by IFS
    gcloud compute disks delete --quiet --project=$PROJECT --zone=${PARTS[1]} ${PARTS[0]}
done
