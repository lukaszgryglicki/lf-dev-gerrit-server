#!/bin/bash
. ./env.sh
./delete_service.sh || exit 1
./delete_ssh_listener.sh  || exit 2
./delete_https_listener.sh  || exit 3
./delete_nlb.sh || exit 4
./delete_alb.sh || exit 5
./delete_target_group_ssh.sh || exit 6
./delete_target_group_http.sh || exit 7
./delete_task_definition.sh || exit 8
./delete_role.sh || exit 9
./delete_mount_targets.sh || exit 10
./delete_volumes.sh || exit 11
./delete_subnets_routes.sh || exit 12
./delete_subnets.sh || exit 13
./delete_route.sh || exit 14
./delete_route_table.sh || exit 15
./delete_inet_gw.sh || exit 16
./delete_security_group.sh || exit 17
./delete_vpc.sh || exit 18
./delete_log_group.sh || exit 19
./delete_cluster.sh || exit 20
