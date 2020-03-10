# webmethods-devops-ansible

An ansible template project for webMethods products automated provisioning and management

## Adding it as a submodule to your project

```bash
git submodule add https://github.com/lanimall/webmethods-devops-ansible.git webmethods-ansible
```

## Some sysprep tasks:

Optional if not done: let's remove tty requiremewnt for SUDO (temp thing until we use the right ansible user)

```
ansible-playbook -i inventory sagenv-sysprep-disabletty.yaml 
```

Then, let's sysprep everything:
```
ansible-playbook -i inventory sagenv-sysprep-all.yaml 
```

Then, install / configure Command Central:
```
ansible-playbook -i inventory sagenv-stack-cce.yaml
```

Sub tasks if more granularity needed:
```
ansible-playbook -i inventory sagenv-stack-cce.yaml --tags sysprep,install
ansible-playbook -i inventory sagenv-stack-cce.yaml --tags sysprep,configure
```

And if you weant to force the re-configuration of CCE:
```
ansible-playbook -i inventory sagenv-stack-cce.yaml --tags configure --extra-vars='{"configure_cce_force": true}'
```

And if you want to force a specific CCE configuration item:
```
ansible-playbook -i inventory sagenv-stack-cce.yaml --tags configure-repo-images --extra-vars='{"configure_cce_force": true}'
```

If you just need to copy the CCE code to command central (ie. you modified it and want to make sure the latest is on the server)
```
ansible-playbook -i inventory sagenv-stack-cce.yaml --tags sync-cce-provisoning
```

## Some component installation tasks:

Note: it's a good idea to use nohup for the installs, as they can be lengthy and we would want everything to continue installing even if we lose connectivity to the server...

```
nohup ansible-playbook -i inventory <playbook_name> &> ~/nohup-<playbook_name>.out &
```

## Some tooling tasks

### Start/Stop products using product scripts:

Params:
 - inventory_groupnames: the ansible inventory group name (ie. where to run this script)
 - product_name: one of the wM product name
 - product_instance_name: instance name
 - product_command: start, stop

```
ansible-playbook -i inventory sagenv-tools-command-product.yaml --extra-params {"inventory_groupnames":"","product_name":"","product_instance_name":"","product_command":""}
```

For example, start all UM servers:

```
ansible-playbook -i inventory sagenv-tools-command-product.yaml --extra-vars '{"inventory_groupnames":"universalmessaging","product_name":"universalmessaging","product_instance_name":"umserver","product_command":"start"}'
```

For example, start all MWS servers:

```
ansible-playbook -i inventory sagenv-tools-command-product.yaml --extra-vars '{"inventory_groupnames":"mws","product_name":"mws","product_instance_name":"default","product_command":"start"}'
```

### Create products services

Params:
 - inventory_groupnames: the ansible inventory group name (ie. where to run this script)
 - product_name: one of the wM product name
 - product_instance_name: instance name
 - product_command: start, stop, restart, update, create

For example, create systemd service for MWS:

```
ansible-playbook -i inventory sagenv-tools-service-product.yaml --extra-vars '{"inventory_groupnames":"mws","product_name":"mws","product_instance_name":"default","product_command":"create"}'
```

Then, update the systemd service with some extra configuration:

```
ansible-playbook -i inventory sagenv-tools-service-product.yaml --extra-vars '{"inventory_groupnames":"mws","product_name":"mws","product_instance_name":"default","product_command":"update"}'
```

Finally, start the systemd service:

```
ansible-playbook -i inventory sagenv-tools-service-product.yaml --extra-vars '{"inventory_groupnames":"mws","product_name":"mws","product_instance_name":"default","product_command":"start"}'
```