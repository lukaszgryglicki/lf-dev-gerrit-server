# lf-dev-gerrit-server
Gerrit Server for Dev use by LF


# Provision

- `` ./up.sh ``.


# Decommission

- `` ./down.sh ``.


# List

- `` ./list.sh ``.


# One time

- Build helper image to get gerrit files from `/var/gerrit`: `` ./build_helper_image.sh ``.
- Run helper image: `` ./run_helper_image.sh ``.
- Copy `gerrit.tar` from the helper container: `` ./copy_from_helper_image.sh ``.
- Copy `gerrit.tar` into Fargate task via `` ./sftp_into_task.sh ``. The deployed task must have both `gerrit` and `openssh` containers.
- Put `gerrit.tar` on persistent volume - for example: `sudo mv /config/gerrit.tar /data/db/gerrit.tar` while inside `` ./ssh_into_task.sh ``.
- Run `ssh_copy_saml.sh` as `root` (`sudo /bin/bash`) while inside the `openssh` container. It creates `/data/lib/saml.jar` file.
- Login to gerrit - that user will become an administrator due to initial setting `DEVELOPMENT_BECOME_ANY_ACCOUNT` in `[auth]` section of `gerrit.config` file.
- Go to [SSH Keys](https://gerrit.dev.platform.linuxfoundation.org/settings/#SSHKeys) - copy you public SSH key(s) there, so you can access the gerrit server via SSH.
- Copy-paste for example: `~/.ssh/id_rsa.pub` file.
- Confirm that you are recognized as an admin: `` ./gerrit_admin_ssh.sh ``, it should return something like: `gerrit version 3.11.1`. This means SSH access is configured properly.
- Confirm that there is `Administrators` group: `` ./gerrit_admin_cmd.sh ls-groups ``.
- Put `gerrit.config` in `/data/etc/gerrit.config` using openssh `ssh` and `sftp` access, replace `{{gerrit-client-id}}` with contects of `gerrit_client_id.secret` file.
- Redeploy gerrit server: `` ./redeploy_service.sh  ``. Wait until new task is running and the old one is not (otherwise auth mode won't be `SAML` yet). You may need to stop tasks manually or recreate service.
- Login to gerrit again this time using `SAML LF auth0`. Then we will make that user admin too.
- Go to [SSH Keys](https://gerrit.dev.platform.linuxfoundation.org/settings/#SSHKeys) - copy you public SSH key(s) there, so you can access the gerrit server via SSH.
- Copy-paste for example: `~/.ssh/id_rsa.pub` file. Emails from SSH key and from LF auth0 must match.
- Check gerrit SSH access: `` ./gerrit_ssh.sh ``, it should return something like: `gerrit version 3.11.1`. This means SSH access is configured properly.
- Add your user to `Administators` group: `` ./gerrit_admin_cmd.sh set-members Administrators --add username ``.
- Check if user can see `Administrators` group: `` ./gerrit_cmd.sh ls-groups ``.


# Other

- Get public IP: `` [GETENI=1] ./get_eni_public_ip.sh ``.
- SSH into the OpenSSH test task: `` [GETIP=1] ./ssh_into_task.sh ``.
- SFTP into the OpenSSH test task: `` [GETIP=1] ./sftp_into_task.sh ``.
- Update task definition: `` ./delete_task_definition.sh && ./create_task_definition.sh && ./update_service.sh ``.
- To shell into the gerrit server container: `` ./shell_into_gerrit.sh ``.
- To check gerrit SSH access (not OpenSSH): `` ./gerrit_ssh.sh ``.
- To execute gerrit SSH command: `` ./gerrit_cmd cmd-name [params] ``.
- To cleanup gerrit to its initial state, execute `` ./reset_gerrit.sh `` while inside `` ./ssh_into_task `` using `sudo ./reset_gerrit.sh ``.
- To craete task with only OpenSSH server and gerrit volumes mounted use `` SSH=1 ./create_task_definition.sh `` and then `` NOLB=1 ./create_service.sh ``.
- To reload gerrit config: `` ./gerrit_cmd.sh reload-config `` or `` ./gerrit_admin_cmd.sh reload-config ``.
