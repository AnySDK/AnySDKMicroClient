package com.anysdk.h5.microclient;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;

import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import com.anysdk.framework.PluginWrapper;
import com.anysdk.framework.java.AnySDK;
import com.anysdk.h5.microclient.R;

public class MainActivity extends Activity {

	WebView mWebView;
	String sGameUrl = "file:///android_asset/gameindex.html";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		Log.d("app", " =========================MainActivity===================== ");

		mWebView = (WebView) findViewById(R.id.webview);  
		
		//初始化AnySDK
		AnyController anyController = new AnyController();
		anyController.initAnySDK(this, mWebView);
		
		//设置WebView支持JS，并将AnyController设置为WebView的扩展对象
	    mWebView.getSettings().setJavaScriptEnabled(true);
	    mWebView.addJavascriptInterface(anyController, "gameshell");
	    mWebView.setWebViewClient(new WebViewClient() {
			   @Override
			   public boolean shouldOverrideUrlLoading(WebView view, String url) { 
			     view.loadUrl(url); 
			     return true; 
			   }
	    });
	    
	    //加载游戏 
	    mWebView.loadUrl(sGameUrl);
	}
	
	@Override
	protected void onDestroy() {
		AnySDK.getInstance().release();
	    PluginWrapper.onDestroy();
	    super.onDestroy();
	}

	@Override
	protected void onPause() {
	    PluginWrapper.onPause();
	    super.onPause();
	}

	@Override
	protected void onResume() {
	    PluginWrapper.onResume();
	    super.onResume();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	    PluginWrapper.onActivityResult(requestCode, resultCode, data);
	    super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	protected void onNewIntent(Intent intent) {
	    PluginWrapper.onNewIntent(intent);
	    super.onNewIntent(intent);
	}

	@Override
	protected void onStop() {
	    PluginWrapper.onStop();
	    super.onStop();
	}

	@Override
	protected void onRestart() {
	    PluginWrapper.onRestart();
	    super.onRestart();
	}

	@Override
	public void onBackPressed() {
	    PluginWrapper.onBackPressed();
	    super.onBackPressed();
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
	    PluginWrapper.onConfigurationChanged(newConfig);
	    super.onConfigurationChanged(newConfig);
	}

	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
	    PluginWrapper.onRestoreInstanceState(savedInstanceState);
	    super.onRestoreInstanceState(savedInstanceState);
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
	    PluginWrapper.onSaveInstanceState(outState);
	    super.onSaveInstanceState(outState);
	}

	@Override
	protected void onStart() {
	    PluginWrapper.onStart();
	    super.onStart();
	}
}

