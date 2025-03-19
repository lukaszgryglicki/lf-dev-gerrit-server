#!/bin/bash
usr=$(cat ./username.secret)
ssh -o Port=29418 -i /root/.ssh/id_rsa_lgryglickidev "${usr}@54.158.223.77"
