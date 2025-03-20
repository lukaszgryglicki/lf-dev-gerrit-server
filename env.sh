#!/bin/bash
if [ -z "${STAGE}" ]
then
  echo "$0: you must specify STAGE=dev or STAGE=prod"
  exit 251
fi
if ( [ ! "${STAGE}" = "dev" ] && [ ! "${STAGE}" = "prod" ] )
then
  echo "$0: STAGE must be either dev or prod"
  exit 252
fi
