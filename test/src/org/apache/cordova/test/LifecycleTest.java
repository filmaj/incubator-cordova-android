package org.apache.cordova.test;

import android.test.ActivityInstrumentationTestCase2;
import android.view.View;

public class LifecycleTest extends ActivityInstrumentationTestCase2<CordovaWebViewTestActivity> {
  
    private static final long TIMEOUT = 1000;
    private CordovaWebViewTestActivity testActivity;
    private View testView;
    
  public LifecycleTest() {
      super("com.phonegap.test.activities", CordovaWebViewTestActivity.class);
  }
  
  protected void setUp() throws Exception {
      super.setUp();
      testActivity = this.getActivity();
      testView = testActivity.findViewById(R.id.phoneGapView);
      this.testActivity.loadUrl("file:///android_asset/www/index.html");
    }

    public void testPreconditions() {
      assertNotNull(testView);
    }

    public void testForCordovaView() {
      String className = testView.getClass().getSimpleName();
      assertTrue(className.equals("CordovaWebView"));
    }
}
