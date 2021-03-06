#!/bin/bash
set -euo pipefail

git fetch upstream
git checkout master
git rebase upstream/master
