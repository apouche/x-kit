#!/usr/bin/env sh

set -ex
set -o pipefail

if [ "$GIT_BRANCH" == "master" ]; then
  CONFIGURATION="Release"
else
  CONFIGURATION="AdHoc"
fi

# Variables
ROOT_PATH="$PWD"
BUILD_PATH="$ROOT_PATH/build"
PRODUCT_NAME="__APP_NAME__"
ARCHIVE_NAME="${CONFIGURATION}-${PRODUCT_NAME}"
INFO_PATH="project/support/Info.plist"
DSYM_PATH="build/${ARCHIVE_NAME}.xcarchive/dSYMs"
DERIVED_DATA_PATH="/tmp/DerivedData-$GIT_BRANCH"
SHORT_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ${INFO_PATH})

PROV_PATH_APP="apple/profiles/${PRODUCT_NAME}_${CONFIGURATION}.mobileprovision"
PROV_UUID_APP=$(cat "$PROV_PATH_APP" | grep -a -oE "(?:\w{4,12}-){4}\w{4,12}")
#PROV_PATH_EXT="apple/profiles/${PRODUCT_NAME}_${CONFIGURATION}_Sharing.mobileprovision"
#PROV_UUID_EXT=$(cat "$PROV_PATH_EXT" | grep -a -oE "(?:\w{4,12}-){4}\w{4,12}")

# Add build number to bundle version
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER}" ${INFO_PATH}

# Build
xctool \
 -configuration $CONFIGURATION \
 -workspace "$PRODUCT_NAME.xcworkspace" \
 -scheme $PRODUCT_NAME \
 -derivedDataPath $DERIVED_DATA_PATH \
 PROV_UUID_APP="${PROV_UUID_APP}" \
 archive -archivePath "${BUILD_PATH}/$ARCHIVE_NAME.xcarchive"
 #PROV_UUID_EXT="${PROV_UUID_EXT}" \

# Zip dsym
#zip -r9y "build/${ARCHIVE_NAME}.dSYM.zip" "${DSYM_PATH}/${PRODUCT_NAME}.app.dSYM"

# IPA Creation
xcrun -sdk iphoneos PackageApplication \
  -v "$BUILD_PATH/$ARCHIVE_NAME.xcarchive/Products/Applications/$PRODUCT_NAME.app" \
  -o "$BUILD_PATH/$ARCHIVE_NAME.ipa"
