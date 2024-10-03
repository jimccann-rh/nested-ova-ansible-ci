#!/bin/bash

export VCESXIPASSWORD="${vcenter_password}"
export MAINVCPASSWORD="${vcenter_password}"
export MAINVCUSERNAME="${vcenter_username}"
export MAINVCHOSTNAME="${vcenter_password}"

joinByChar() {
  local IFS="$1"
  shift
  echo "$*"
}

export NAMESPACE=${NAMESPACE:-ci-op-test}
export HOST_COUNT=${HOST_COUNT:-1}
export VCPUS=${VCPUS:-24}
export MEMORY=${MEMORY:-96}

export VCPUS_PER_HOST=$((VCPUS / HOST_COUNT))
export MEMORY_PER_HOST=$(((MEMORY / HOST_COUNT) * 1024))

HOSTS=()

for ((i=1; i<=HOST_COUNT; i++)); do
    HOSTS+=("$NAMESPACE-host-$i")
done

TARGET_HOSTS=$(joinByChar , "${HOSTS[@]}")
VCENTER_NAME="$NAMESPACE-vcenter"

ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": ['$TARGET_HOSTS']}' --extra-var='{"target_vcs": ['$VCENTER_NAME']}' --extra-var esximemory="${MEMORY_PER_HOST}" --extra-var esxicpu="${VCPUS_PER_HOST}"