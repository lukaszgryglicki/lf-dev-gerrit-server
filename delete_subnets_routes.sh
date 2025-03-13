#!/bin/bash
for z in a b c d e f
do
  subnetid=$(cat "subnet-1${z}.json.secret" | jq -r '.Subnet.SubnetId')
  echo "Subnet us-east-1${z} id: ${subnetid}"
  if [ ! -z "${subnetid}" ]
  then
    if [ -f "route-1${z}.json.secret" ]
    then
      aid=$(cat "route-1${z}.json.secret" | jq -r '.AssociationId')
      if [ -z "${aid}" ]
      then
        echo "$0: cannot get association id"
        continue
      fi
      aws --profile lfproduct-dev ec2 disassociate-route-table --association-id "${aid}"
      res=$?
      if [ ! "${res}" = "0" ]
      then
        echo "$0: disassociate route failed"
      else
        echo "association id: ${aid} removed"
        rm -f "route-1${z}.json.secret"
      fi
    else
      echo "$0: no route association for us-east-1${z}"
    fi
  else
    echo "$0: cannot find subnet for us-east-1${z}"
  fi
done
