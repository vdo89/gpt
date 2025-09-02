# Variables

## global_config
Key | Description
--- | ---
cluster_deployment | Deployment mode (agent, ipmi, redfish)
agent_provider | Provider for agent-based installs (e.g., proxmox)
platform | OpenShift platform (none or baremetal)
cluster_name | Cluster name
cluster_baseDomain | Base domain for the cluster
machine_cidr | Machine network CIDR

## Sample Inventory
A minimal agent-based example is provided in `ansible/inventory/agent.example.yaml`.
