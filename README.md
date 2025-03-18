# lf-dev-gerrit-server
Gerrit Server for Dev use by LF


# Provision

- `` ./up.sh ``.


# Decommission

- `` ./down.sh ``.


# List

- `` ./list.sh ``.


# Other

- Get public IP: `` [GETENI=1] ./get_eni_public_ip.sh ``.
- SSH into the OpenSSH test task: `` [GETIP=1] ./ssh_into_task.sh ``.


# One tiume
- Build helper image to get gerrit files from `/var/gerrit`: `` ./build_helper_image.sh ``.
- Run helper image: `` ./run_helper_image.sh ``.
- Copy gerrit.tar from the helper container: `` ./copy_from_helper_image.sh ``.
