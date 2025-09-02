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
