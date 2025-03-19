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
- Create groups: `` ./gerrit_cmd.sh create-group sun-ccla ``, `` ./gerrit_cmd.sh create-group sun-icla ``.
- List new groups: `` ./gerrit_cmd.sh ls-groups -v `` - note their UUIDs.
- Clone `All-Projects` repo: `` ./gerrit_clone_all_projects.sh ``.
- Add `sun-icla` and `sun-ccla` groups to `All-Projects/groups` file, like this:
```
ae49883ef22d7e57e82651c78d4cc455446fbdef  sun-ccla
1206bf3a96be239b4e9ac51429315488221df783  sun-icla
```
- Update `All-Projects/project.config` with the following changes:
  - in the `[receive]` section: change `requireContributorAgreement`, `requireSignedOffBy`, `enableSignedPush` from `false` to `true`.
  - in the `[receive]` section: add `requireSignedPush = false`.
  - in then`[access "refs/meta/config"]` section add:
  ```
    push = +force group Administrators
    forgeAuthor = group Administrators
    forgeCommitter = group Administrators
  ```
  - add sections:
  ```
  [contributor-agreement "CCLA"]
    description = CCLA (Corporate Contributor License Agreement) for SUN
    agreementUrl = https://api.dev.lfcla.com/v2/gerrit/c64998ab-833d-4d55-8b83-04e7d3398c99/corporate/agreementUrl.html
    accepted = group sun-ccla
  [contributor-agreement "ICLA"]
    description = ICLA (Individual Contributor License Agreement) for SUN
    agreementUrl = https://api.dev.lfcla.com/v2/gerrit/c64998ab-833d-4d55-8b83-04e7d3398c99/individual/agreementUrl.html
    accepted = group sun-icla
  ```
  - TODO: note usage of `c64998ab-833d-4d55-8b83-04e7d3398c99` UUID here - this should be UUID from `DynamoDB` gerrit server instance (`gerrit-instances` table) - this is per-project gerrit server entry UUID.
- Typical changes are similar to `all-projects.diff`.
- Install gerrit commit hooks: `` cd All-Projects && ../gerrit_commit_hooks.sh  && cd .. ``.
- Commit `All-Projects` changes: `` cd All-Projects && ../gerrit_commit_all_projects_changes.sh && cd .. ``.
- Add push permission for `refs/meta/config` branch [here](https://gerrit.dev.platform.linuxfoundation.org/admin/repos/All-Projects,access):
  - Click `Edit`, locate `refs/meta/config` choose `Add permission`: `Push`, click `Add`. Choose group `Administrators`, allow both with and without force.
  - Do the same with `Forge Author Identity` and `Forge Comitter Identity`.
- Push `All-Projects` changes: `` cd All-Projects && ../gerrit_push_all_projects_changes.sh && cd .. ``.

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
- `gerrit-saml.tar` is a backup of all persistent volumes data after `admin` user was added using "1st login mode" and then one LFID user was added by SAML auth (also admin).
- `gerrit-configured.tar` is a backup made by `./backup_gerrit.sh` while using `GETIP=1 ssh_into_task.sh` after all changes to `All-Projects` were pushed.
