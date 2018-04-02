#!/bin/bash -x

# Knowing Script dir beware of symlink
[[ -L ${0} ]] && SCRIPT_DIR=$(readlink ${0}) || SCRIPT_DIR=${0}
SCRIPT_DIR="${SCRIPT_DIR%/*}"

if [[ -z ${ARCH} ]]; then
  echo "ARCH variable not set!"
  exit 1
fi

if [[ -z ${DISTRO} ]]; then
  echo "DISTRO variable not set!"
  exit 1
fi

# In ignition this variable is passed directly from the DSL job creation
if [[ -z ${ABI_JOB_SOFTWARE_NAME} ]]; then
  echo "ABI_JOB_SOFTWARE_NAME not set!"
  exit 1
fi

# convert from ign-package to IGN_PACKAGE_DEPENDENCIES
ABI_JOB_PKG_DEPENDENCIES_VAR_NAME=$(\
  echo ${ABI_JOB_SOFTWARE_NAME} \
  | tr '[:lower:]-' '[:upper:]_')_DEPENDENCIES

export ABI_JOB_REPOS="stable"

. ${SCRIPT_DIR}/lib/generic-abi-base.bash
