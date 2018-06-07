#!/bin/bash -x

# Knowing Script dir beware of symlink
[[ -L ${0} ]] && SCRIPT_DIR=$(readlink ${0}) || SCRIPT_DIR=${0}
SCRIPT_DIR="${SCRIPT_DIR%/*}"

cat > build.sh << DELIM
###################################################
# Make project-specific changes here
#
#!/usr/bin/env bash
set -ex

RESULT_DIR=${WORKSPACE}/cppcheck_results

[[ -d ${RESULT_DIR} ]] && rm -fr ${RESULT_DIR}
mkdir ${RESULT_DIR}

echo '# BEGIN SECTION: run shellcheck'
cd ${WORKSPACE}/repo
find . -name '*.bash' -exec shellcheck --shell=bash --exclude SC2034 --formatcheckstyle  --  {} \\; >  build/cppcheck_results/*.xml

echo '# END SECTION'
DELIM

OSRF_REPOS_TO_USE=${OSRF_REPOS_TO_USE:=stable}
DEPENDENCY_PKGS="devscripts \
		 ubuntu-dev-tools \
		 debhelper \
		 wget \
                 shellcheck"

. ${SCRIPT_DIR}/lib/docker_generate_dockerfile.bash
. ${SCRIPT_DIR}/lib/docker_run.bash