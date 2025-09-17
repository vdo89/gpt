# Architecture

## Core Pieces
- Provisioning host: a Linux box that runs installers, builds agent ISOs, and stages cluster configs.
- Orchestrator: Ansible collection with roles to prepare host, configure networking, create infra, run installers, and post-configure the cluster.
- Infra drivers: OpenTofu/Terraform for VM creation, plus IPMI/Redfish controls or Proxmox APIs.
- DNS providers: InfoBlox (implemented) and RFC2136 (planned).
- Post-install: Sealed Secrets, OpenShift GitOps, NTP machineconfigs, console plugins.
- Optional mirroring: oc-mirror to populate a private registry for air-gapped environments.

## Deployment Modes
- **IPI Bare Metal (IPMI/Redfish)**: uses `openshift-baremetal-install create cluster`. Requires DNS A records for API and apps wildcard.
- **Agent-Based (e.g., Proxmox)**: renders `install-config.yaml` and `agent-config.yaml`, builds an Agent ISO, uploads to provider, and waits for install.

## End-to-End Flow
1. Validate inventory schema and required keys (cluster name, mode, platform, VIPs, etc.).
2. Prepare provisioning host: create user, install packages/libvirt, fetch installer/oc, set up storage, add pull-secret.
3. Configure network bridges and IPs using modules.
4. Render configs (`install-config.yaml`, `agent-config.yaml`).
5. Configure DNS records.
6. Provision infrastructure via OpenTofu/TF or power controls.
7. Run installer (IPI or Agent) and wait for completion.
8. Apply post-install components (Sealed Secrets, GitOps, NTP, console plugins).
9. Cleanup: remove DNS records, destroy infra, purge bootstrap artifacts.

### Embedded Debug Checks per Stage
To keep failures observable without introducing extra operators, the pipeline now embeds the recommended debug checks:

1. **Inventory validation** – rerun the playbook with `-vvv` (or `--step` for interactive runs) to capture rich context whenever schema validation fails, helping pinpoint the missing or malformed key at the very start of the run.
2. **Host preparation & networking** – after host/network tasks complete, the pipeline inspects verbose Ansible logs and confirms that required packages, bridges, and static IP assignments (including DNS records) were applied before moving on.
3. **Config rendering & prereq confirmation** – each render task records the generated manifests and cross-checks prerequisites (rendered install/agent configs, infrastructure creation success) so upstream configuration issues are spotted before the installer runs.
4. **Installer execution** – the deploy stage guides operators to check `oc get csv -n <namespace>` and `oc describe csv <name>` along with controller pod logs when the installer or dependent operators misbehave.
5. **Post-install components** – when reconciling custom resources, the runbook now points to `oc describe <CRD> <name>` and `oc get events -n <namespace>` so validation or reconciliation errors are captured together with the pipeline output.

These guardrails provide a single troubleshooting path and prevent adding unrelated operators unless the embedded checks confirm the existing components are healthy.
