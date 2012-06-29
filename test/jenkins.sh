#/bin/sh

ANDROID_REPO=/Users/fil/src/incubator-cordova-android
ANDROID_TEST=$ANDROID_REPO/test
MOBILE_SPEC=/Users/fil/src/incubator-cordova-mobile-spec
ANDROID_SDK=/Users/fil/SDKs/android-sdk-macosx
ADB=$ANDROID_SDK/platform-tools/adb
VERSION=`cat $ANDROID_REPO/version`

# If we are this far it is assumed that the jar was compiled
# successfully

mkdir $ANDROID_TEST/assets/www/mobilespec

# 1. Copy the jar into the test directory
cp -f $ANDROID_REPO/framework/cordova-$VERSION.jar $ANDROID_TEST/libs/.

# 2. Copy the JS
cp -f $ANDROID_REPO/framework/assets/js/cordova.android.js $ANDROID_TEST/assets/www/.
# .. also into the mobilespec directory
cp -f $ANDROID_REPO/framework/assets/js/cordova.android.js $ANDROID_TEST/assets/www/mobilespec/cordova-$VERSION.js

# 3. Get latest mobile-spec
cd $MOBILE_SPEC && git checkout master && git pull

# 4. Copy mobile-spec into our test project
cp -rf $MOBILE_SPEC/a* $MOBILE_SPEC/b* $MOBILE_SPEC/c* $MOBILE_SPEC/e* $MOBILE_SPEC/i* $MOBILE_SPEC/l* $MOBILE_SPEC/m* $MOBILE_SPEC/n* $MOBILE_SPEC/s* $ANDROID_TEST/assets/www/mobilespec/. 

# 5. Compile the app
cd $ANDROID_TEST && ant debug

exit 0;

/Users/fil/SDKs/android-sdk-macosx/platform-tools/adb shell am instrument -w org.apache.cordova.test/android.test.InstrumentationTestRunner && \
/Users/fil/SDKs/android-sdk-macosx/platform-tools/adb pull /mnt/sdcard/Android/data/org.apache.cordova.test/cache ${WORKSPACE}/${JOB_NAME}/xmls
