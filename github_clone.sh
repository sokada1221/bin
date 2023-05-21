#!/usr/bin/env bash
set -euo pipefail

# Requirements:
# 1. Install hub
#   # brew install hub
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


# 0. User confirmation
echo "Following will be performed:"
echo "1. Clone ${PROJECT_URI} at ${GIT_PROJECT_ROOT}/${ORGANIZATION_NAME}/${PROJECT_NAME}"
echo "Continue? (y/n)"
read confirmation

if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
    exit
fi

# 1. Clone target repo and fork on Github
echo "Cloning target repo"
if [ -d "${GIT_PROJECT_ROOT}/${PROJECT_URI}" ]; then
  echo "${PROJECT_URI} seems to be cloned already. Do you want to clone from scratch? (y/n)"
  read confirmation
  if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
      exit
  fi
  rm -rf ${GIT_PROJECT_ROOT}/${PROJECT_URI}
  cd ${GIT_PROJECT_ROOT}/${ORGANIZATION_NAME}
else
  cd ${GIT_PROJECT_ROOT}
  mkdir -p ${ORGANIZATION_NAME}
  cd ${ORGANIZATION_NAME}
fi

hub clone ${PROJECT_URI}
cd ${PROJECT_NAME}

echo
echo "Your clone of ${PROJECT_URI} is ready at:"
pwd
echo "Happy coding!"

exit
