package org.apache.cordova.test.mobilespec;

public class AccelerometerAutoTest extends CordovaMobileSpecAutoTest {
    public AccelerometerAutoTest() {
        super("file:///android_asset/www/mobilespec/autotest/pages/accelerometer.html");
    }
    
    /**
     *  "dummy" test to wait until the test page is done.
     * the jasmine JUnit reporter will change the webview title once all tests are done and the report is written out. 
     */
    public void testShitIsDone() {
        while (!this.webviewTest.done) {
            sleep();
        }
        assertTrue(this.webviewTest.done);
    }
}
