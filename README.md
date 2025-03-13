# lf-dev-gerrit-server
Gerrit Server for Dev use by LF


# Provision

1) `` ./create_vpc.sh ``.
2) `` ./create_subnets.sh ``.
3) `` ./create_security_group.sh ``.
4) `` ./create_volumes.sh ``.



# Decommission

1) `` ./delete_volumes.sh ``.
2) `` ./delete_security_group.sh ``.
3) `` ./delete_subnets.sh ``.
4) `` ./delete_vpc.sh ``.
