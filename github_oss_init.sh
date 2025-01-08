#!/usr/bin/env bash
set -euo pipefail

# Requirements:
# 1. Install gh
#   # brew install gh
#
# Usage:
# oss_init_github.sh uber/cadence

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
echo "2. Fork ${PROJECT_URI} at ${GIT_USERNAME}/${PROJECT_NAME}"
echo "3. Clone ${GIT_USERNAME}/${PROJECT_NAME} at ${GIT_PROJECT_ROOT}/${GIT_USERNAME}/${PROJECT_NAME}"
echo "4. Configure upstream remote at ${GITHUB_URL_PREFIX}/${PROJECT_URI}${GITHUB_URL_SUFFIX} and disable push"
echo "Continue? (y/n)"
read confirmation

if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
    exit
fi

# 1. Clone target repo and fork on Github
echo "Cloning target repo and forking on Github"
if [ -d "${GIT_PROJECT_ROOT}/${PROJECT_URI}" ]; then
  echo "${PROJECT_URI} seems to be cloned already. Do you still want to continue? (y/n)"
  read confirmation
  if [ "$confirmation" = "${confirmation#[Yy]}" ]; then
      exit
  fi
  cd ${GIT_PROJECT_ROOT}/${ORGANIZATION_NAME}
else
  cd ${GIT_PROJECT_ROOT}
  mkdir -p ${ORGANIZATION_NAME}
  cd ${ORGANIZATION_NAME}
  gh repo clone ${PROJECT_URI}
fi

cd ${PROJECT_NAME}
gh repo set-default ${PROJECT_URI}
gh repo fork --remote

# 2. Clone a fork and set upstream
echo "Cloning a fork and configuring upstream"
cd ${GIT_PROJECT_ROOT}
mkdir -p ${GIT_USERNAME}
cd ${GIT_USERNAME}
gh repo clone ${GIT_USERNAME}/${PROJECT_NAME}
cd ${PROJECT_NAME}
# git remote add upstream ${GITHUB_URL_PREFIX}/${PROJECT_URI}${GITHUB_URL_SUFFIX}
git remote set-url --push upstream no_push

echo
echo "Your fork of ${PROJECT_URI} is ready at:"
pwd
git remote -v
echo "Happy coding!"

exit
