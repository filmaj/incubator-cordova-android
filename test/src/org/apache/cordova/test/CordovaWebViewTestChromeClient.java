package org.apache.cordova.test;

import org.apache.cordova.CordovaChromeClient;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.LOG;

import android.webkit.WebView;

public class CordovaWebViewTestChromeClient extends CordovaChromeClient {
    
    private TitleListener listener;

    public CordovaWebViewTestChromeClient(CordovaInterface cordova) {
        super(cordova);
    }
    public CordovaWebViewTestChromeClient(CordovaInterface cordova, CordovaWebView webview, TitleListener listener) {
        super(cordova, webview);
        this.listener = listener;
    }
    
    @Override
    public void onReceivedTitle (WebView view, String title) {
        LOG.d("WebViewTestChromeClient","TITLE CHANGED! " + title);
        this.listener.onTitleChanged(title);
    }
}
