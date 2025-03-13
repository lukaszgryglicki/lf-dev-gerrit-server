#!/bin/bash
./create_cluster.sh || exit 1
./create_vpc.sh || exit 2
./create_security_group.sh || exit 3
./create_inet_gw.sh || exit 4
./create_route_table.sh  || exit 5
./create_route.sh || exit 6
./create_subnets.sh || exit 7
./create_subnets_routes.sh || exit 8
./update_subnets.sh || exit 9
./create_volumes.sh || exit 10
./create_mount_targets.sh || exit 11
./create_task_definition.sh || exit 12
./create_service.sh || exit 13
echo 'all ok'
