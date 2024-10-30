#!/bin/bash

VERSION_REGEX="([0-9]{1,}\.)+[0-9]{1,}"
BUILD_TIME=$(date +"%a, %d %b %Y %T %z")
BUILD_DATE=$(date  +"%a %b %d %Y")
VERSION_NUMBER=$(grep "project.*" CMakeLists.txt | egrep -o "${VERSION_REGEX}")
WORKSPACE="$GITHUB_WORKSPACE"
INSTALL_PREFIX="$WORKSPACE/tmp"

echo "BUILD_TYPE=$BUILD_TYPE" >> $GITHUB_ENV
echo "BUILD_TIME=$BUILD_TIME" >> $GITHUB_ENV
echo "BUILD_DATE=$BUILD_DATE" >> $GITHUB_ENV
echo "WORKSPACE=$WORKSPACE" >> $GITHUB_ENV
echo "INSTALL_PREFIX=$INSTALL_PREFIX" >> $GITHUB_ENV
echo "VERSION_NUMBER=$VERSION_NUMBER" >> $GITHUB_ENV
echo "UPLOADTOOL_ISPRERELEASE=true" >> $GITHUB_ENV
echo "BUILD_TESTS=OFF" >> $GITHUB_ENV
echo "BUILD_EXAMPLE=OFF" >> $GITHUB_ENV
echo "LIB=$LIB;$INSTALL_PREFIX/lib" >> $GITHUB_ENV
echo "INCLUDE=$INCLUDE;$INSTALL_PREFIX/include" >> $GITHUB_ENV
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH;$INSTALL_PREFIX/lib/pkgconfig" >> $GITHUB_ENV


if [[ "$GITHUB_REF" = refs/tags* ]]; then
    GITHUB_TAG=${GITHUB_REF#refs/tags/}
    echo "GitHub Tag is: $GITHUB_TAG"
    echo "GITHUB_TAG=$GITHUB_TAG" >> $GITHUB_ENV
else
    echo "GitHub Ref is: $GITHUB_REF"
fi

if [[ "${BUILD_TYPE}" = "debug" ]]; then
    VERSION_BUILD_TYPE="-${BUILD_TYPE}"
else
    VERSION_BUILD_TYPE=""
fi

if [[ -z "${GITHUB_TAG}" ]]; then
    echo "Build is not tagged this is a continuous build"
    VERSION_SUFFIX="continuous"
    echo "VERSION_SUFFIX=$VERSION_SUFFIX" >> $GITHUB_ENV
    echo "VERSION=${VERSION_NUMBER}${VERSION_BUILD_TYPE}-${VERSION_SUFFIX}" >> $GITHUB_ENV
else
    echo "Build is tagged this is not a continues build"
    echo "Building ksnip-plugin-ocr version ${VERSION_NUMBER}"
    echo "VERSION=${VERSION_NUMBER}${VERSION_BUILD_TYPE}" >> $GITHUB_ENV
fi


# Message show on the release page
ACTION_LINK_TEXT="Build logs: https://github.com/rholak/ksnip-plugin-ocr/actions"
BUILD_TIME_TEXT="Build Time: $(date +"%a, %d %b %Y %T")"
UPLOADTOOL_BODY="${ACTION_LINK_TEXT}\n${BUILD_TIME_TEXT}"
echo "UPLOADTOOL_BODY=$UPLOADTOOL_BODY" >> $GITHUB_ENV