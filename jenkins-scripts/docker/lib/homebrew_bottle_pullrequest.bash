#!/bin/bash -x

# Knowing Script dir beware of symlink
[[ -L ${0} ]] && SCRIPT_LIBDIR=$(readlink ${0}) || SCRIPT_LIBDIR=${0}
SCRIPT_LIBDIR="${SCRIPT_LIBDIR%/*}"
export SCRIPT_DIR=${SCRIPT_LIBDIR}/../

export DOCKER_JOB_NAME="homebrew_bottle_pullrequest"
. ${SCRIPT_LIBDIR}/boilerplate_prepare.sh

# directory to find the .json file generated by brew-bot with the hash
# TODO: send the directory from the DSL
BOTTLE_JSON_DIR=${WORKSPACE}/pkgs

echo '# BEGIN SECTION: check variables'
if [ -z "${PULL_REQUEST_URL}" ]; then
  echo PULL_REQUEST_URL not specified
  exit -1
fi

cat > build.sh << DELIM
###################################################
#
set -ex

mkdir -p /home/linuxbrew/

PULL_REQUEST_API_URL=\$(echo ${PULL_REQUEST_URL} \
  | sed -e 's@^https://github\.com/@https://api.github.com/repos/@' \
        -e 's@/pull/\([0-9]\+\)/*$@/pulls/\1@')
PULL_REQUEST_HEAD_REPO=\$(curl \${PULL_REQUEST_API_URL} \
  | python3 -c 'import json, sys; print(json.loads(sys.stdin.read())["head"]["repo"]["ssh_url"])')
PULL_REQUEST_BRANCH=\$(curl \${PULL_REQUEST_API_URL} \
  | python3 -c 'import json, sys; print(json.loads(sys.stdin.read())["head"]["ref"])')
echo '# END SECTION'

# note that matrix projects use subdirectories on pkgs/ with the
# label of different configurations
FILES_WITH_NEW_HASH="\$(find \${BOTTLE_JSON_DIR} -name '*.json')"

# call to github setup
. ${SCRIPT_LIBDIR}/_homebrew_github_setup.bash

if [ -z "${TAP_PREFIX}" ]; then
	echo TAP_PREFIX not specified
	exit -1
fi

echo "# BEGIN SECTION: update bottle hashes"

\${BREW} bottle --merge --write --no-commit \${FILES_WITH_NEW_HASH}

# ensure that all modified files are committed
export FORMULA_PATH='-a'

echo '# END SECTION'

COMMIT_MESSAGE_SUFFIX=" bottle."
. ${SCRIPT_LIBDIR}/_homebrew_github_commit.bash
DELIM

export DEPENDENCY_PKGS="apt-transport-https \
                 curl \
		 libz-dev \
                 git"

. "${SCRIPT_LIBDIR}/docker_generate_dockerfile.bash"
. "${SCRIPT_LIBDIR}/docker_run.bash"
