#!/bin/bash
./create_cluster.sh || exit 1
./create_log_group.sh || exit 2
./create_vpc.sh || exit 3
./create_security_group.sh || exit 4
./create_inet_gw.sh || exit 5
./create_route_table.sh  || exit 6
./create_route.sh || exit 7
./create_subnets.sh || exit 8
./create_subnets_routes.sh || exit 9
./update_subnets.sh || exit 10
./create_volumes.sh || exit 11
./create_mount_targets.sh || exit 12
# SSH=1 ./create_task_definition.sh || exit 13
./create_task_definition.sh || exit 14
./create_service.sh || exit 15
./create_alb.sh || exit 16
echo 'all ok'
