![Obol Logo](https://obol.tech/obolnetwork.png)

# obol-ansible
Obol's Ansible Playbooks

## Available playbooks

- [`charon-node`](charon-node.yml)
- [`charon-cluster`](charon-cluster.yml)

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
You have the followin charon node artifacts generated locally under a .charon folder:

- validator-keys
- charon-enr-private-key
- cluster-lock

### Run the role

```
ansible-playbook -e config.beacon_node_endpoints=<beacon_node_endpoints> -i <hosts.yml> charon-node.yml
```

### Charon Cluster

A distributed validator cluster is a docker-compose file with the following containers running:

- Single execution layer client
- Single consensus layer client
- Number of Distributed Validator clients [This playbook]
- Number of Validator clients
- Prometheus, Grafana and Jaeger clients for monitoring this cluster.
- Distributed Validator Cluster

![Distributed Validator Cluster](https://github.com/ObolNetwork/charon-distributed-validator-cluster/blob/main/DVCluster.png?raw=true)

### Prerequisites
You have the followin charon artifacts generated locally under a .charon folder per each node:

- nodeX/validator-keys
- nodeX/charon-enr-private-key
- nodeX/cluster-lock

### Run the role

```
ansible-playbook -e config.beacon_node_endpoints=<beacon_node_endpoints> -i <hosts.yml> charon-cluster.yml
```