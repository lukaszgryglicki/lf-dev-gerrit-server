# lf-dev-gerrit-server
Gerrit Server for Dev use by LF


# Provision

1) `` ./create_vpc.sh ``.
2) `` ./create_inet_gw.sh ``.
3) `` ./create_subnets.sh ``.
4) `` ./create_security_group.sh ``.
5) `` ./create_volumes.sh ``.
6) `` ./create_mount_targets.sh ``.



# Decommission

1) `` ./delete_mount_targets.sh ``.
1) `` ./delete_volumes.sh ``.
2) `` ./delete_security_group.sh ``.
3) `` ./delete_subnets.sh ``.
4) `` ./delete_inet_gw.sh ``.
5) `` ./delete_vpc.sh ``.
