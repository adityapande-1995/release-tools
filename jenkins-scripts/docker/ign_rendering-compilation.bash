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

export BUILDING_SOFTWARE_DIRECTORY="ign-rendering"
export BUILDING_JOB_REPOSITORIES="stable"
export BUILDING_DEPENDENCIES="libignition-common-dev libignition-math4-dev libfreeimage-dev libx11-dev libmesa-dev libogre-1.9-dev"
if [[ $(date +%Y%m%d) -le 20180115 ]]; then
  ## need prerelease repo to get ignition-cmake during the development cycle
  export BUILDING_JOB_REPOSITORIES="${BUILDING_JOB_REPOSITORIES} prerelease"
fi

export GPU_SUPPORT_NEEDED=true

. ${SCRIPT_DIR}/lib/generic-building-base.bash
