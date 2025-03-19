#!/bin/bash
./delete_service.sh || exit 1
./delete_https_listener.sh  || exit 2
./delete_alb.sh || exit 3
./delete_target_group.sh || exit 4
./delete_task_definition.sh || exit 5
./delete_role.sh || exit 6
./delete_mount_targets.sh || exit 7
./delete_volumes.sh || exit 8
./delete_subnets_routes.sh || exit 9
./delete_subnets.sh || exit 10
./delete_route.sh || exit 11
./delete_route_table.sh || exit 12
./delete_inet_gw.sh || exit 13
./delete_security_group.sh || exit 14
./delete_vpc.sh || exit 15
./delete_log_group.sh || exit 16
./delete_cluster.sh || exit 17
