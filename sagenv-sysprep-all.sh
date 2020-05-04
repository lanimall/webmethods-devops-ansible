#!/usr/bin/env bash

set -e

nohup ansible-playbook -i inventory ./sagenv-sysprep-all.yaml &> $HOME/nohup-sagenv-sysprep-all.yaml.out &

tail -f $HOME/nohup-sagenv-sysprep-all.yaml.out