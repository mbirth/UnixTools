#!/bin/sh
#cat configure | grep PACKAGE_NAME | sed 

PKG_NAME=`cat configure | grep "PACKAGE_NAME=" | sed -r "s/^.*=['\"]?([^'\"]*)['\"]?$/\1/g"`
PKG_VERSION=`cat configure | grep "PACKAGE_VERSION=" | sed -r "s/^.*=['\"]?([^'\"]*)['\"]?$/\1/g"`
PKG_VERSION=`cat FISH-BUILD-VERSION-FILE | grep "FISH_BUILD_VERSION =" | sed -r "s/^.* = ['\"]?([^'\"]*)['\"]?$/\1/g"`
PKG_OLDCODE=`ls -1vr ./${PKG_NAME}_${PKG_VERSION}* | head -n 1 | sed -r "s/^.*${PKG_NAME}_${PKG_VERSION}-(.*)_.*$/\1/g"`
PKG_CODE=`expr $PKG_OLDCODE + 1`
SPEC_FILE=`ls -1r ./*.spec`
echo "Package: ${PKG_NAME}_${PKG_VERSION}-${PKG_CODE}"
checkinstall --maintainer="markus@birth-online.de" --pkgname="$PKG_NAME" --pkgversion="$PKG_VERSION" --pkgrelease="$PKG_CODE" --requires="xsel"
