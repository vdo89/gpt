# os-deploy

Ansible collection and playbooks that automate provisioning and deployment of
OpenShift clusters. The `rws.openshift` collection contains roles for preparing
the provisioning host, configuring networking and DNS, creating infrastructure,
invoking OpenShift installers, and performing post-install configuration.

## Quick start

```bash
make deps   # install required collections and tooling
make lint   # run ansible-lint and yamllint
make deploy # run full deployment using example inventory
```

See `docs/` for architecture and variable documentation.
