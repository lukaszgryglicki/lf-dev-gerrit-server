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
./create_role.sh || exit 13
./create_task_definition.sh || exit 14
./create_target_group_http.sh || exit 15
./create_target_group_ssh.sh || exit 16
./create_alb.sh || exit 17
./create_nlb.sh || exit 18
./add_route53.sh || exit 19
./create_cert.sh || exit 20
./validate_cert.sh || exit 21
./create_https_listener.sh  || exit 22
./create_ssh_listener.sh  || exit 23
./create_service.sh || exit 24
echo 'all ok'
