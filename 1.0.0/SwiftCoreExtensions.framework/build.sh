#!/bin/sh

#  build.sh
#  SwiftCoreExtensions
#
#  Created by Xoliswa on 2019/10/30.
#  Copyright © 2019 AppRoot. All rights reserved.

# create folder where we place built frameworks
mkdir build

name=SwiftCoreExtensions
project=SwiftCoreExtensions.xcodeproj
scheme=SwiftCoreExtensions
framework=SwiftCoreExtensions.framework

# build framework for simulators
xcodebuild clean build \
  -project ./$project \
  -scheme $scheme \
  -configuration Release \
  -sdk iphonesimulator \
  -derivedDataPath derived_data
  
# create folder to store compiled framework for simulator
mkdir build/simulator

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphonesimulator/$framework build/simulator

#build framework for devices
xcodebuild clean build \
  -project ./$project \
  -scheme $scheme \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath derived_data
  
# create folder to store compiled framework for simulator
mkdir build/devices

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphoneos/$framework build/devices

# create folder to store compiled universal framework
mkdir build/universal

####################### Create universal framework #############################

# copy device framework into universal folder
cp -r build/devices/$framework build/universal/

# create framework binary compatible with simulators and devices, and replace binary in unviersal framework
lipo -create \
  build/simulator/$framework/$name \
  build/devices/$framework/$name \
  -output build/universal/$framework/$name
  
# copy simulator Swift public interface to universal framework
cp build/simulator/$framework/Modules/$name.swiftmodule/* build/universal/$framework/Modules/$name.swiftmodule
