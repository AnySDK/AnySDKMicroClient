//
//  AnyController.mm
//  WebDemo
//
//  Created by WangChris on 2017/10/25.
//  Copyright © 2017年 AnySDK@Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AnyController.h"

AnyController* AnyController::_pInstance = NULL;

AnyController* AnyController::getInstance()
{
    if (_pInstance == NULL) {
        _pInstance = new AnyController();
    }
    return _pInstance;
}

void AnyController::purge()
{
    if (_pInstance)
    {
        delete _pInstance;
        _pInstance = NULL;
    }
}

AnyController::AnyController()
{
    _pluginsIAPMap = NULL;
}

AnyController::~AnyController()
{
    _pAgent->unloadAllPlugins();
}

void AnyController::setWebView(WKWebView* vcWebView)
{
    webView = vcWebView;
}

void AnyController::initAnySDK()
{
    //为了便于母包测试，iOS使用的框架为线上(越狱版)，如果需要上架AppStore请参考文档替换框架
    //详见 http://docs.anysdk.com/faq/ios-sdk-params/#appstore
    //此处参数请替换成自己游戏的值，母包测试和获取账号请参考 http://docs-old.anysdk.com/Debug-User
    
    string appKey = "D58E9234-9F1C-93C3-801E-5993BA8957AC";
    string appSecret = "7f23a389100d2c6ed8bebd4ff3e0b3e3";
    string privateKey = "0D4E4671DC91C7230A2EE9121AD91425";
    string oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
    
    _pAgent = AgentManager::getInstance();
    _pAgent->init(appKey, appSecret, privateKey, oauthLoginServer);
    _pAgent->loadAllPlugins();
    
    //对用户系统设置监听类
    _pUser = _pAgent->getUserPlugin();
    if(_pUser)
    {
        _pUser->setActionListener(this);
    }
    
    //对支付系统设置监听类
    _pluginsIAPMap  = _pAgent->getIAPPlugin();
    std::map<std::string , ProtocolIAP*>::iterator iter;
    for(iter = _pluginsIAPMap->begin(); iter != _pluginsIAPMap->end(); iter++)
    {
        (iter->second)->setResultListener(this);
    }
}

void AnyController::login()
{
    _pUser->login();
}

void AnyController::pay()
{
    ProtocolIAP::resetPayState();
    std::map<std::string , ProtocolIAP*>::iterator it = _pluginsIAPMap->begin();
    NSLog(@"plugin length %lu", _pluginsIAPMap->size());
    if(_pluginsIAPMap)
    {
        productInfo["Product_Id"] = "1";
        productInfo["Product_Name"] = "10元宝";
        productInfo["Product_Price"] = "1";
        productInfo["Product_Count"] = "1";
        productInfo["Product_Desc"] = "gold";
        productInfo["Coin_Name"] = "MonthCard";
        productInfo["Coin_Rate"] = "10";
        productInfo["Role_Id"] = "123456";
        productInfo["Role_Name"] = "test";
        productInfo["Role_Grade"] = "1";
        productInfo["Role_Balance"] = "1";
        productInfo["Vip_Level"] = "1";
        productInfo["Party_Name"] = "test";
        productInfo["Server_Id"] = "1";
        productInfo["Server_Name"] = "test";
        productInfo["EXT"] = "test";
        if(_pluginsIAPMap->size() == 1)
        {
            (it->second)->getPluginId().c_str();
            (it->second)->payForProduct(productInfo);
        }
        else if(_pluginsIAPMap->size() > 1)
        {
            //多种支付方式，详见对应语言支付部分文档
        }
    }
}

void AnyController::onPayResult(PayResultCode ret, const char* msg, TProductInfo info)
{
    printf("onPayResult, %s\n", msg);
    if(webView)
    {
        NSString *inputValueJS = [NSString stringWithFormat:@"payResult('%@','%@');",[NSString stringWithFormat:@"%d",ret],@"msg"]; //JS层需要用到回调msg请进一步处理
        [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        }];
    }
    switch(ret)
    {
        case kPaySuccess://支付成功回调
        break;
        case kPayFail://支付失败回调
        break;
        case kPayCancel://支付取消回调
        break;
        case kPayNetworkError://支付超时回调
        break;
        case kPayProductionInforIncomplete://支付超时回调
        break;
        case kPayNowPaying://正在支付状态回调
        break;
        default:
        break;
    }
}

void AnyController::onActionResult(ProtocolUser* pPlugin, UserActionResultCode code, const char* msg)
{
    printf("PluginChannel, onActionResult:%d, msg:%s\n",code,msg);
    if(webView)
    {
        NSString *inputValueJS = [NSString stringWithFormat:@"loginResult('%@','%@');",[NSString stringWithFormat:@"%d",code],@"msg"];//JS层需要用到回调msg请进一步处理
        [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        }];
    }
    switch(code)
    {
        case kInitSuccess://初始化SDK成功回调
        NSLog(@"anysdk framework version is: %s ", _pUser->getSDKVersion().c_str());
        break;
        case kInitFail://初始化SDK失败回调
        break;
        case kLoginSuccess://登陆成功回调
        break;
        case kLoginNoNeed:  //不需要登陆
        break;
        case kLoginNetworkError://登陆失败回调
        break;
        case kLoginCancel://登陆取消回调
        break;
        case kLoginFail://登陆失败回调
        break;
        case kLogoutSuccess://登出成功回调
        break;
        case kLogoutFail://登出失败回调
        break;
        case kPlatformEnter://平台中心进入回调
        break;
        case kPlatformBack://平台中心退出回调
        break;
        case kPausePage://暂停界面回调
        break;
        case kExitPage://退出游戏回调
        break;
        case kAntiAddictionQuery://防沉迷查询回调
        break;
        case kRealNameRegister://实名注册回调
        break;
        case kAccountSwitchSuccess://切换账号成功回调
        break;
        case kAccountSwitchFail://切换账号成功回调
        break;
        default:
        break;
    }
}

void AnyController::onRequestResult(RequestResultCode ret, const char* msg, AllProductsInfo info)
{
    //商品展示，可忽略
}

