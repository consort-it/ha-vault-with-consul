#!/bin/bash

CONSUL_ADDRESS='http://127.0.0.1:9500'

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# use consul to fetch all "todo" service instances and their health status
function getAddresses() {
  CONSUL_ADDR=$1
  SERVICE=$2

  SVC_DATA=$(curl -sk -u consort:Lcw\$37f\+I5\-\;8WQs $CONSUL_ADDR/v1/health/service/$SERVICE)
  LEN=$(echo $SVC_DATA | jq '. | length')
  IDX=$(expr $LEN - 1)
  for i in `seq 0 $IDX`; do
    HEALTH='passing'
    CHECK_LEN=$(echo $SVC_DATA | jq ".[$i].Checks | length")
    CHECK_IDX=$(expr $CHECK_LEN - 1)
    for j in `seq 0 $CHECK_IDX`; do
      STATUS=$(echo $SVC_DATA | jq .[$i].Checks[$j].Status | sed -e 's/^"//'  -e 's/"$//')
      if [ "$STATUS" != "passing" ]; then
        # no warnings in demo, only passing or critical
        HEALTH=$STATUS
        break
      fi
    done

    PORT=$(echo $SVC_DATA | jq .[$i].Service.Port)
    ADDR=$(echo $SVC_DATA | jq .[$i].Node.Address | sed -e 's/^"//'  -e 's/"$//')

    echo -e "$ADDR:$PORT\t$HEALTH"
  done
}

function displayVaultStatus() {
  ADDRESSES=$(getAddresses "$1" "vault")
  HEALTHY_INSTANCE='no'

  echo -e "Address\t\t\tSeal Status\tHealth\t\tLeader"

  while read -r RESULT; do
    ADDR=$(echo $RESULT | awk '{print $1}')
    HEALTH=$(echo $RESULT | awk '{print $2}')

    DISP=$ADDR

    SEALED=$(curl -sk $ADDR/v1/sys/seal-status | jq .sealed)
    if [ "$SEALED" != "false" ]; then
      DISP="${DISP}\t${RED}sealed${NC}\t"
    else
      DISP="${DISP}\t${GREEN}unsealed${NC}"
    fi

    if [ "$HEALTH" == "passing" ]; then
      HEALTHY_INSTANCE='yes'

      DISP="${DISP}\t${GREEN}${HEALTH}${NC}"

      IS_LEADER=$(curl -sk $ADDR/v1/sys/leader | jq .is_self)
      if [ "$IS_LEADER" == "true" ]; then
        DISP="${DISP}\t\t*"
      fi

    else
      DISP="${DISP}\t${RED}${HEALTH}${NC}"
    fi

    echo -e $DISP

  done <<< "$ADDRESSES"

  if [ "$HEALTHY_INSTANCE" == "yes" ]; then
    echo -e "\nOK: Service 'vault' is functioning correctly."
    return 0
  else
    echo -e "\nFAIL: There are no healthy 'vault' instances available"
    return 1
  fi
}

# run it
displayVaultStatus $CONSUL_ADDRESS
