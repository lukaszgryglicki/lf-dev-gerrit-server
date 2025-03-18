#!/bin/bash
./delete_service.sh || exit 1
./delete_https_listener.sh  || exit 2
./delete_alb.sh || exit 3
./delete_target_group.sh || exit 4
./delete_task_definition.sh || exit 5
./delete_mount_targets.sh || exit 6
./delete_volumes.sh || exit 7
./delete_subnets_routes.sh || exit 8
./delete_subnets.sh || exit 9
./delete_route.sh || exit 10
./delete_route_table.sh || exit 11
./delete_inet_gw.sh || exit 12
./delete_security_group.sh || exit 13
./delete_vpc.sh || exit 14
./delete_log_group.sh || exit 15
./delete_cluster.sh || exit 16
