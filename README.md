![Obol Logo](https://obol.tech/obolnetwork.png)

# obol-ansible
Obol's Ansible Playbooks

## Available playbooks

- [`charon_node`](charon_node.yml)
- [`charon_cluster`](charon_cluster.yml)

## Before you begin

### Prerequisites

- Ansible 2.13.2+

### Installing Ansible

For installing and setting up Ansible please refer to the [setup guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Running a play

### Charon Node

A distributed validator node is a machine running:

- An Ethereum Execution client
- An Ethereum Consensus client
- An Ethereum Distributed Validator client [This playbook]
- An Ethereum Validator client

![Distributed Validator Node](https://github.com/ObolNetwork/charon-distributed-validator-node/blob/main/DVNode.png?raw=true)

### Prerequisites
You have the following charon node artifacts generated locally under a .charon folder:

- validator-keys
- charon-enr-private-key
- cluster-lock

### Install dependencies

Install the required Ansible collections:

```
ansible-galaxy install -r requirements.yml
```

### Run the role

```
ansible-playbook -i <hosts.yml> charon-node.yml
```

`beacon_node_endpoints` is required. Set it in `group_vars/all.yml` or pass it
inline:

```
ansible-playbook -i <hosts.yml> -e beacon_node_endpoints=<beacon_node_endpoints> charon-node.yml
```

### How it works (charon_node)

By default, this playbook only deploys the Charon node container. You can
optionally enable a local beacon node pair and validator client.

When enabled, the flow is:
- Create or reuse a docker network (default: dvnode)
- Start mev-boost (optional)
- Start the execution client (nethermind/geth/besu/reth)
- Start the consensus client (lighthouse/teku/lodestar/nimbus/prysm/grandine)
- Start Charon (connected to the same network)
- Start a validator client (lodestar/nimbus/prysm/teku)
- Start Prometheus (optional)
- Start Alloy (optional)

### Configuration overview

Set variables in `group_vars/all.yml` (or override with `-e`):

- `beacon_node_endpoints`: required for Charon. Use a local client when `deploy_beacon_node: true`.
- `deploy_beacon_node`, `execution_client`, `consensus_client`: deploy an EL/CL pair.
- `deploy_validator_client`, `validator_client`: deploy a validator client (teku, lighthouse, lodestar, nimbus, prysm).
- `deploy_mev_boost`, `mevboost_relays`: enable builder and relays.
- `deploy_prometheus`, `prom_remote_write_*`: enable metrics (remote write optional).
- `deploy_alloy`, `alloy_loki_addresses`: enable log shipping to Loki.

Consensus client API ports:
- lighthouse/teku/lodestar/nimbus/grandine: `5052`
- prysm: `3500`

### Example: use an external beacon node

```
deploy_beacon_node: false
beacon_node_endpoints: "https://your-bn.example.com:5052"
```

### CDVN parity and optional services

This playbook can optionally deploy:
- mev-boost (builder)
- prometheus (metrics)
- alloy (logs)

Grafana and Jaeger are still out of scope (bring your own).

### Optional: deploy beacon node + validator client

You can deploy an execution+consensus pair and a validator client on the same host.
Enable the roles in `group_vars/all.yml`:

```
deploy_beacon_node: true
execution_client: nethermind
consensus_client: lighthouse

deploy_validator_client: true
validator_client: nimbus
```

Set `beacon_node_endpoints` to the consensus client inside Docker:

```
beacon_node_endpoints: "http://lighthouse:5052"
```

### Example: deploy full local stack (EL+CL+VC+mev-boost+observability)

```
deploy_beacon_node: true
execution_client: nethermind
consensus_client: lighthouse
beacon_node_endpoints: "http://lighthouse:5052"

deploy_validator_client: true
validator_client: nimbus

deploy_mev_boost: true
mevboost_relays:
  - https://relay.flashbots.net

deploy_prometheus: true
prom_service_owner: "dv-operator"
prom_remote_write_enabled: true
prom_remote_write_token: "<token>"

deploy_alloy: true
alloy_loki_addresses: "https://loki.example.com/loki/api/v1/push"
alloy_nickname: "dvnode-1"
```

If `deploy_mev_boost` is enabled and `builder_endpoint` is empty, the beacon
node role defaults to `http://mev-boost:18550`.

Supported consensus/execution pairs (from obol-infrastructure/argocd):
- grandine + nethermind
- lighthouse + geth/nethermind/reth
- lodestar + geth/nethermind
- nimbus + besu/nethermind
- prysm + geth
- teku + geth/nethermind

Supported validator clients:
- lodestar
- lighthouse
- nimbus
- prysm
- teku

Default validator client versions (from `group_vars/all.yml`):
- teku v25.12.0
- lighthouse v8.0.1
- lodestar v1.38.0
- nimbus v25.11.1
- prysm v7.1.0

All validator clients above are compatible with any supported consensus client.

### Connect the validator client

- Update the validator client to connect to charon node API endpoint instead of the beacon node endpoint --beacon-node-api-endpoint="http://charon0:3600"

### Charon Cluster

A distributed validator cluster is a host running:

- Optional execution layer client
- Optional consensus layer client
- One Charon node per nodeX artifact
- Optional validator clients
- Optional Prometheus and Alloy (Grafana and Jaeger are out of scope)

![Distributed Validator Cluster](https://github.com/ObolNetwork/charon-distributed-validator-cluster/blob/main/DVCluster.png?raw=true)

### Prerequisites
You have the following charon artifacts generated locally under a .charon folder per each node:

- nodeX/validator-keys
- nodeX/charon-enr-private-key
- nodeX/cluster-lock

### Install dependencies

Install the dependent ansible packages by running:

```
ansible-galaxy install -r requirements.yml
```

### Run the role

```
ansible-playbook -i <hosts.yml> charon-cluster.yml
```

`beacon_node_endpoints` is required. Set it in `group_vars/all.yml` or pass it
inline:

```
ansible-playbook -i <hosts.yml> -e beacon_node_endpoints=<beacon_node_endpoints> charon-cluster.yml
```

### Cluster notes

- `deploy_beacon_node`, `deploy_mev_boost`, `deploy_prometheus`, and `deploy_alloy` run once per host.
- `charon_cluster` still creates one Charon node per `nodeX` artifact.

### Connect the validator client

- Update each validator client to connect to charon node API endpoint instead of the beacon node endpoint --beacon-node-api-endpoint="http://charon`<node-index>`:3600"
