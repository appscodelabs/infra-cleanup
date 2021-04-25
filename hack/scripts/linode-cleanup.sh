#!/bin/bash

set -eou pipefail

# linode-cli volumes list --json --pretty > /tmp/linode_volumes.json

# cat /tmp/linode_volumes.json | jq -r '.[]| select (.linode_id == null) | .id'

for vol in $(linode-cli volumes list --json --pretty | jq -r '.[]| select (.linode_id == null) | .id'); do
	linode-cli volumes delete $vol || true
	sleep 1
done
