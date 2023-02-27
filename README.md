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

### Prerequisites
You have the followin charon artifacts generated locally under a .charon folder per each node:

- nodeX/validator-keys
- nodeX/charon-enr-private-key
- nodeX/cluster-lock

### Run the role

```
ansible-playbook -e config.beacon_node_endpoints=<beacon_node_endpoints> -i <hosts.yml> charon-cluster.yml
```