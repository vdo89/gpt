Provision Host Role
===================

Prepares the provisioning node for running OpenShift installers. It creates the
provisioning user, installs required packages, configures libvirt, and fetches
OpenShift client tools. The role also installs Butane and optionally configures
system-wide proxy settings.

Variables
---------

* `provision_user` – user account to create (default: `kni`)
* `provision_user_password_hash` – optional hashed password for the user
* `provision_user_ssh_public_key` – public key added to the user's
  `authorized_keys`
* `provision_packages` – list of packages to install
* `provision_pull_secret` – OpenShift pull secret content
* `provision_oc_url` – URL to download the `oc` client archive
* `provision_installer_release_image` – release image for extracting
  `openshift-baremetal-install`
* `provision_butane_url` – URL to download the Butane binary
* `provision_proxy` – dictionary of proxy environment variables

Example
-------

```yaml
- hosts: os-prov
  roles:
    - role: rws.openshift.provision_host
      vars:
        provision_pull_secret: "{{ lookup('file', 'pull-secret.txt') }}"
```
