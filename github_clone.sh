#!/usr/bin/env bash
set -euo pipefail

# Requirements:
# 1. Install gh
#   # brew install gh
#
# Usage:
# clone_github.sh jgrapht/jgrapht

# User config
GIT_PROJECT_ROOT=~/git
GIT_USERNAME=sokada1221

# Arguments
PROJECT_URI=${1}
ORGANIZATION_NAME=$(dirname ${PROJECT_URI})
PROJECT_NAME=$(basename ${PROJECT_URI})

# Constants
GITHUB_URL_PREFIX="https://github.com"
GITHUB_URL_SUFFIX=".git"

CLONE_TARGET_DIR="${GIT_PROJECT_ROOT}/${ORGANIZATION_NAME}/${PROJECT_NAME}"
CLONE_WORKING_DIR="${GIT_PROJECT_ROOT}/${ORGANIZATION_NAME}"
# Lyft-specific overrides
if [[ "${ORGANIZATION_NAME}" == "lyft" ]]; then
    GIT_PROJECT_ROOT=~/src
    CLONE_TARGET_DIR="${GIT_PROJECT_ROOT}/${PROJECT_NAME}"
    CLONE_WORKING_DIR="${GIT_PROJECT_ROOT}"
fi


# 0. User confirmation
echo "Following will be performed:"
echo "1. Clone ${PROJECT_URI} at ${CLONE_TARGET_DIR}"
echo "Continue? (y/n)"
read confirmation

if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
    exit
fi

# 1. Clone target repo and fork on Github
echo "Cloning target repo"
if [ -d "${CLONE_TARGET_DIR}" ]; then
  echo "${PROJECT_URI} seems to be cloned already. Do you want to clone from scratch? (y/n)"
  read confirmation
  if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
      exit
  fi
  rm -rf ${CLONE_TARGET_DIR}
  cd ${CLONE_WORKING_DIR}
else
  mkdir -p ${CLONE_WORKING_DIR}
  cd ${CLONE_WORKING_DIR}
fi

gh repo clone ${PROJECT_URI}
cd ${PROJECT_NAME}

echo
echo "Your clone of ${PROJECT_URI} is ready at:"
pwd
echo "Happy coding!"

exit
