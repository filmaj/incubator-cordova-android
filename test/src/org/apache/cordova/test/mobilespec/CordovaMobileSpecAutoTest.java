package org.apache.cordova.test.mobilespec;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.test.*;

import android.test.ActivityInstrumentationTestCase2;

public class CordovaMobileSpecAutoTest extends ActivityInstrumentationTestCase2<CordovaWebViewTestActivity> {
    
    protected int TIMEOUT = 1000;
    protected CordovaWebView webview;
    protected CordovaWebViewTestActivity webviewTest;
    protected String url;

    public CordovaMobileSpecAutoTest(String loadUrl) {
        super(CordovaWebViewTestActivity.class);
        this.url = loadUrl;
    }
    
    protected void setUp() throws Exception {
        if (this.url == null) return;
        super.setUp();
        this.webviewTest = ((CordovaWebViewTestActivity)this.getActivity());
        this.webview = webviewTest.phoneGap;
        this.webview.loadUrl(this.url);
    }
    
    protected void sleep() {
        try {
          Thread.sleep(TIMEOUT);
        } catch (InterruptedException e) {
          fail("Unexpected Timeout");
        }
    }
}
