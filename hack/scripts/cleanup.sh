#!/bin/bash

PROJECT=appscode-testing

for name in $(gcloud container clusters list --project=$PROJECT --format='value(name)')
do
	gcloud container clusters delete --project=$PROJECT $name # --async
done

for name in $(gcloud compute disks list --project=$PROJECT --format='value(name)')
do
	gcloud compute disks delete --project=$PROJECT $name
done
