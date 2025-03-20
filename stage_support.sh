#!/bin/bash
for f in *.sh
do
  if ( [ "${f}" = "env.sh" ] || [ "${f}" = "add_stage_support.sh" ] || [ "${f}" = "stage_support.sh" ] )
  then
    echo "$0: skipping '${f}'"
    continue
  fi
  ./add_stage_support.sh "${f}"
done
