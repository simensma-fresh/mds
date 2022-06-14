#!/bin/bash

set -e

# To Be Updated to reflect PROD

MINESPACE_CURRENT=$(curl https://mds-dev.apps.silver.devops.gov.bc.ca/api/version/ -s | jq .commit -r | cut -d '-' -f 3)
CORE_WEB_CURRENT=$(curl https://mds-dev.apps.silver.devops.gov.bc.ca/api/version/ -s | jq .commit -r | cut -d '-' -f 3)
CORE_API_CURRENT=$(curl https://mds-dev.apps.silver.devops.gov.bc.ca/api/version/ -s | jq .commit -r | cut -d '-' -f 3)

HEAD_HASH=$(git rev-parse --verify HEAD)

echo -e "====================================================================================="
echo "Current Minespace Version: $MINESPACE_CURRENT Target Deploy Version: $HEAD_HASH"
echo -e "====================================================================================="

# Update to reference service current sha.
MINESPACE_PROMOTION_LIST=$(git --no-pager log --oneline 0c677d43949343849df05df755705f474d3c3ea0...$HEAD_HASH | grep -oh "\w*MDS-*\w*" | awk '{print $1}' | paste -s -d, -)

echo "https://bcmines.atlassian.net/jira/software/c/projects/MDS/issues/?jql=project= \"MDS\" AND issuekey IN ($MINESPACE_PROMOTION_LIST) ORDER BY status ASC"
