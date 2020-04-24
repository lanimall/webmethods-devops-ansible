#!/usr/bin/env bash

set -e

nohup ansible-playbook -i inventory ./sagenv-stack-cce-full.yaml &> $HOME/nohup-sagenv-stack-cce-full.out &
echo "provisionning sagenv-stack-cce-full in progress... check $HOME/nohup-sagenv-stack-cce-full.out for progress"