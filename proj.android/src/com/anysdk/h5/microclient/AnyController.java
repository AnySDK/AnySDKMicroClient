package com.anysdk.h5.microclient;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.util.Log;
import android.webkit.JavascriptInterface;
import com.tencent.smtt.sdk.WebView;
import android.widget.Toast;

import com.anysdk.framework.IAPWrapper;
import com.anysdk.framework.UserWrapper;
import com.anysdk.framework.java.AnySDK;
import com.anysdk.framework.java.AnySDKIAP;
import com.anysdk.framework.java.AnySDKListener;
import com.anysdk.framework.java.AnySDKUser;

public class AnyController {
	private final String TAG_STRING = "ANYSDK";
	Activity mActivity;
	WebView mWebView;
	
	/**
	 * 初始化AnySDK
	 * @param activity
	 * @param webview
	 */
	public void initAnySDK(Activity activity, WebView webview) {
		mActivity = activity;
		mWebView = webview;
		
		String appKey = "23186D32-ACEC-62A3-1377-88F5F868692A";
		String appSecret = "a321931aa35d9ad8d5c0e904d768edd5";
		String privateKey = "98130039F40377035FBDB40F319BF793";
		String oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
		AnySDK.getInstance().init(activity, appKey, appSecret, privateKey, oauthLoginServer);
		
		setListener();
	}
	
	/**
	 * 提供给JS调用的登录接口
	 */
	@JavascriptInterface
    public void login() {  
        AnySDKUser.getInstance().login();
    }
	
	/**
	 * 提供给JS调用的支付接口
	 */
	@JavascriptInterface
    public void pay() {
		Map<String, String> mProductionInfo = new HashMap<String, String>();
		mProductionInfo.put("Product_Id", "1");
		mProductionInfo.put("Product_Name", "10元宝");
		mProductionInfo.put("Product_Price", "1");
		mProductionInfo.put("Product_Count", "1");
		mProductionInfo.put("Product_Desc", "gold");
		mProductionInfo.put("Coin_Name","元宝");
		mProductionInfo.put("Coin_Rate", "10");
		mProductionInfo.put("Role_Id","123456");
		mProductionInfo.put("Role_Name", "test");
		mProductionInfo.put("Role_Grade", "1");
		mProductionInfo.put("Role_Balance", "1");
		mProductionInfo.put("Vip_Level", "1");
		mProductionInfo.put("Party_Name", "test");
		mProductionInfo.put("Server_Id", "1");
		mProductionInfo.put("Server_Name", "test");
		mProductionInfo.put("EXT", "test");
		
		ArrayList<String> idArrayList = AnySDKIAP.getInstance().getPluginId();
		if (idArrayList.size() == 1) {
			AnySDKIAP.getInstance().payForProduct(idArrayList.get(0), mProductionInfo);
		} else {
			//多种支付方式
			//开发者需要自己设计多种支付方式的逻辑及UI
		}
    }
	
	private void setListener() {
		/**
		 * 为用户系统设置监听
		 */
		AnySDKUser.getInstance().setListener(new AnySDKListener() {
			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				
				mWebView.loadUrl("javascript:loginResult("+arg0+", '"+arg1+"')");
				
				switch (arg0) {
				case UserWrapper.ACTION_RET_INIT_SUCCESS:// 初始化SDK成功回调
					break;
				case UserWrapper.ACTION_RET_INIT_FAIL:// 初始化SDK失败回调
					Exit();
					break;
				default:
					break;
				}
			}
		});
		
		/**
		 * 为支付系统设置监听
		 */
		AnySDKIAP.getInstance().setListener(new AnySDKListener() {

			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				
				mWebView.loadUrl("javascript:payResult("+arg0+", '"+arg1+"')");
			}
		});
	}
	
	private void Exit() {
		mActivity.finish();
		System.exit(0);
	}
	
}
