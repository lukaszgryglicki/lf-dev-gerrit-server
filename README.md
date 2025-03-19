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
- Update task definition: `` ./delete_task_definition.sh && ./create_task_definition.sh && ./update_service.sh ``.


# One time

- Build helper image to get gerrit files from `/var/gerrit`: `` ./build_helper_image.sh ``.
- Run helper image: `` ./run_helper_image.sh ``.
- Copy `gerrit.tar` from the helper container: `` ./copy_from_helper_image.sh ``.
- Copy `gerrit.tar` into Fargate task via `` ./sftp_into_task.sh ``. Deploayed task must have both `gerrit` and `openssh` containers.
- Run `ssh_copy_saml.sh` as `root` (`sudo /bin/bash`) while inside the `openssh` container.
- Put `gerrit.config` in `/data/etc/gerrit.config` using openssh `ssh` and `sftp` access, replace `{{gerrit-client-id}}` with contects of `gerrit_client_id.secret` file.
