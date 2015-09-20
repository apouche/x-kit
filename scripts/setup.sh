#!/usr/bin/env sh

set -ex
set -o pipefail

if [ "$1" == "" ]; then
  echo "You must provide a project name"
  exit 1
fi

PROJECT_PATH="$PWD"
PROJECT_NAME="$1"

# remove git folder
rm -rf "${PROJECT_PATH}/.git"

# renames folders & files
find ${PROJECT_PATH} -name "__APP_NAME__*" -type d |xargs rename -v "s/__APP_NAME__/${PROJECT_NAME}/"
find ${PROJECT_PATH} -name "__APP_NAME__*" -type f |xargs rename -v "s/__APP_NAME__/${PROJECT_NAME}/"

# replace all occurences of __APP_NAME__ in all files
find ${PROJECT_PATH} -type f|xargs grep -lIE "[-_]{2}APP[-_]NAME[-_]{2}" |xargs sed -i.remove -E "s/[-_]{2}APP[-_]NAME[-_]{2}/${PROJECT_NAME}/g"
find ${PROJECT_PATH} -type f -name "*.remove"|xargs rm -rf
