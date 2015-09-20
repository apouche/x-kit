#! /bin/sh

set -eu

RES_PATH="${PROJECT_DIR}"
DST_PATH="${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
EXCLUDE="Images.xcassets"
for resource_type in assets; do
  res_path="${RES_PATH}/${resource_type}"
  subfolders=`find ${res_path} -type d -mindepth 1|grep -v ${EXCLUDE}`
  for subfolder in $subfolders; do
    full_path="${subfolder}"
    if [ -d "$full_path" ]; then
      echo "Copying resources from $full_path into ${DST_PATH}"
      rsync -avyz "$full_path/" "${DST_PATH}"
    fi
  done
done
