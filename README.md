# lf-dev-gerrit-server
Gerrit Server for Dev use by LF


# Provision

- `` ./create_cluster.sh ``.
- `` ./create_vpc.sh ``.
- `` ./create_vpc.sh ``.
- `` ./create_inet_gw.sh ``.
- `` ./create_subnets.sh ``.
- `` ./create_security_group.sh ``.
- `` ./create_volumes.sh ``.
- `` ./create_mount_targets.sh ``.
- `` ./create_task_definition.sh ``.
- `` ./create_service.sh ``.


# Decommission

- `` ./delete_service.sh ``.
- `` ./delete_task_definition.sh ``.
- `` ./delete_mount_targets.sh ``.
- `` ./delete_volumes.sh ``.
- `` ./delete_security_group.sh ``.
- `` ./delete_subnets.sh ``.
- `` ./delete_inet_gw.sh ``.
- `` ./delete_vpc.sh ``.
- `` ./delete_cluster.sh ``.
