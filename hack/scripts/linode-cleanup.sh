#!/bin/bash

set -eou pipefail

echo "linode-cli version:"
linode-cli --version

# echo "The following volumes are unattached and will be deleted:"
# linode-cli volumes list --json --pretty --page-size 500 | jq -r '.[]| select (.linode_id == null) | .id'

# ninja cluster
linode-cli lke kubeconfig-view 19953 --json | jq -r '.[0].kubeconfig' | base64 -d >/tmp/kubeconfig_qa
qa_vols=$(kubectl --kubeconfig=/tmp/kubeconfig_qa get pv -o=jsonpath='{range .items[?(@.status.phase=="Bound")]}{.spec.csi.volumeHandle}{"\n"}{end}' | cut -d '-' -f 1 | sort)
# echo $qa_vols

# prod cluster
linode-cli lke kubeconfig-view 25516 --json | jq -r '.[0].kubeconfig' | base64 -d >/tmp/kubeconfig_prod
prod_vols=$(kubectl --kubeconfig=/tmp/kubeconfig_prod get pv -o=jsonpath='{range .items[?(@.status.phase=="Bound")]}{.spec.csi.volumeHandle}{"\n"}{end}' | cut -d '-' -f 1 | sort)
# echo $prod_vols

for vol in $(linode-cli volumes list --json --pretty --page-size 500 | jq -r '.[]| select (.linode_id == null) | .id'); do
	if [[ ${qa_vols[@]} =~ $vol ]]; then
		echo "$vol found in ninja and skipped"
		continue
	fi
	if [[ ${prod_vols[@]} =~ $vol ]]; then
		echo "$vol found in prod and skipped"
		continue
	fi

	echo "$vol will be deleted"
	linode-cli volumes delete $vol || true
	sleep 1
done
