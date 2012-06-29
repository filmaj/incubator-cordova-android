#/bin/sh

set -e

ANDROID_REPO=/Users/fil/src/incubator-cordova-android
ANDROID_TEST=$ANDROID_REPO/test
MOBILE_SPEC=/Users/fil/src/incubator-cordova-mobile-spec
ANDROID_SDK=/Users/fil/SDKs/android-sdk-macosx
ADB=$ANDROID_SDK/platform-tools/adb
VERSION=`cat $ANDROID_REPO/version`
PACKAGE="org.apache.cordova.test"
TEST_PACKAGE="$PACKAGE/android.test.InstrumentationTestRunner"

# List of connected android devices
IDs=`$ADB devices | grep device$ | awk '{print $1}'`

# If we are this far it is assumed that the jar was compiled
# successfully - first step in jenkins does this
rm -rf $ANDROID_TEST/assets/www/mobilespec
mkdir $ANDROID_TEST/assets/www/mobilespec

# 1. Copy the jar into the test directory
rm $ANDROID_TEST/libs/*
cp -f $ANDROID_REPO/framework/cordova-$VERSION.jar $ANDROID_TEST/libs/.

# 2. Copy the JS
cp -f $ANDROID_REPO/framework/assets/js/cordova.android.js $ANDROID_TEST/assets/www/.
# .. also into the mobilespec directory
cp -f $ANDROID_REPO/framework/assets/js/cordova.android.js $ANDROID_TEST/assets/www/mobilespec/cordova-$VERSION.js

# 3. Get latest mobile-spec
cd $MOBILE_SPEC && git checkout master && git pull origin master > /dev/null

# 4. Copy mobile-spec into our test project
cp -rf $MOBILE_SPEC/a* $MOBILE_SPEC/b* $MOBILE_SPEC/c* $MOBILE_SPEC/e* $MOBILE_SPEC/i* $MOBILE_SPEC/l* $MOBILE_SPEC/m* $MOBILE_SPEC/n* $MOBILE_SPEC/s* $ANDROID_TEST/assets/www/mobilespec/. 

# 5. Edit the autotest "all" pages to hook the junit xml reporter into jasmine
AUTOTEST=$ANDROID_TEST/assets/www/mobilespec/autotest/pages/*.html
# drop in the junit xml reporter
sed -i '' -e "s/<script type=.text.javascript. src=.\.\..html.TrivialReporter\.js.><.script>/<script type=\"text\/javascript\" src=\"..\/html\/TrivialReporter.js\"><\/script><script type=\"text\/javascript\" src=\"..\/..\/..\/junit-reporter.js\"><\/script>/g" $AUTOTEST
# wrap jasmine exec in filesystem call
sed -i '' -e "s/var jasmineEnv/window.requestFileSystem(LocalFileSystem.TEMPORARY, 0, function(fs) { var jasmineEnv/g" $AUTOTEST
sed -i '' -e "s/execute.../execute();},function(err) {console.log('ERROR!!!!11');});/g" $AUTOTEST
# add hook in junit into reporter
sed -i '' -e "s/jasmine.HtmlReporter.../jasmine.HtmlReporter(); var jr = new jasmine.JUnitXmlReporter(fs.root.fullPath + '\/');/g" $AUTOTEST
sed -i '' -e "s/addReporter.htmlReporter../addReporter(htmlReporter);jasmineEnv.addReporter(jr);/g" $AUTOTEST

# 6. Compile the app
cd $ANDROID_TEST && ant clean && ant debug > /dev/null

for i in $IDs
do
  # make a directory for the device id
  rm -rf $WORKSPACE/$JOB_NAME/xml/$i
  mkdir -p $WORKSPACE/$JOB_NAME/xml/$i
  # uninstall if its there already
  $ADB -s $i uninstall $PACKAGE
  # install the test apk to each device
  $ADB -s $i install $ANDROID_TEST/bin/tests-debug.apk
  # run on each device
  $ADB -s $i shell am instrument -w $TEST_PACKAGE
  # pull the xml into workspace
  $ADB -s $i pull
  /mnt/sdcard/Android/data/org.apache.cordova.test/cache
  $WORKSPACE/$JOB_NAME/xmls/$i
done
