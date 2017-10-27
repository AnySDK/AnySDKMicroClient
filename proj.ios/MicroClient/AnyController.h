//
//  AnyController.h
//  WebDemo
//
//  Created by WangChris on 2017/10/25.
//  Copyright © 2017年 AnySDK@Cocos. All rights reserved.
//

#import "AgentManager.h"
#import "ViewController.h"
#include <string>

using namespace std;
using namespace anysdk::framework;

class AnyController: public PayResultListener, public UserActionListener
{
public:
    static AnyController* getInstance();
    static void purge();
    
    //从ViewController获取WebView用于回调
    void setWebView(WKWebView* vcWebView);
    
    //初始化AnySDK
    void initAnySDK();
    //登录接口
    void login();
    //支付接口
    void pay();
    
    //支付回调函数
    virtual void onPayResult(PayResultCode ret, const char* msg, TProductInfo info);
    //支付，商品请求回调函数
    virtual void onRequestResult(RequestResultCode ret, const char* msg, AllProductsInfo info);
    //登陆回调函数
    virtual void onActionResult(ProtocolUser* pPlugin, UserActionResultCode code, const char* msg);
    
private:
    AnyController();
    virtual ~AnyController();
    
    static AnyController* _pInstance;
    std::map<std::string, std::string> productInfo;
    std::map<std::string , ProtocolIAP*>* _pluginsIAPMap;
    
    WKWebView *webView;
    AgentManager* _pAgent;
    ProtocolUser* _pUser;
    
};

