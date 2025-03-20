#!/bin/bash
. ./env.sh
rtid=$(cat route-table.json.${STAGE}.secret | jq -r '.RouteTable.RouteTableId')
echo "route table id: ${rtid}"
if [ -z "${rtid}" ]
then
  echo "$0: no route table found"
  exit 1
fi
for z in a b c d e f
do
  subnetid=$(cat "subnet-1${z}.json.${STAGE}.secret" | jq -r '.Subnet.SubnetId')
  echo "Subnet us-east-1${z} id: ${subnetid}"
  if [ ! -z "${subnetid}" ]
  then
    if [ ! -f "route-1${z}.json.${STAGE}.secret" ]
    then
      aws --profile lfproduct-${STAGE} ec2 associate-route-table --route-table-id "${rtid}" --subnet-id "${subnetid}" > "route-1${z}.json.${STAGE}.secret"
      res=$?
      if [ ! "${res}" = "0" ]
      then
        echo "$0: associate route failed"
        rm -f "route-1${z}.json.${STAGE}.secret"
      else
        aid=$(cat "route-1${z}.json.${STAGE}.secret" | jq -r '.AssociationId')
        echo "association id: ${aid}"
      fi
    else
      echo "$0: route association for us-east-1${z} already exists"
    fi
  else
    echo "$0: cannot find subnet for us-east-1${z}"
  fi
done
