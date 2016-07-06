//
//  JKOAuthVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 7/1/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit
import SVProgressHUD

class JKOAuthVC: UIViewController {

    //定义常量区域
    let appKey = "2795635843"
    let appSecret = "14f44971d84942a6dea5c4effaf05a83"
    let redirectURL = "http://www.juziit.net/"
    
    //make a test
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化导航条
        navigationItem.title = "kevin的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(selfClose))
        
        //获取未授权的requestToken
        //要求SSL1.2
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectURL)"
        let url = NSURL(string: urlStr)
        let  request = NSURLRequest(URL:url!)
        
        webView.loadRequest(request)
        
        
    }

    func selfClose(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //懒加载网页视图
    private lazy var webView : UIWebView = {
       let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
    
    
    
}

//实现webview的delegate
extension JKOAuthVC :UIWebViewDelegate{
    //返回true正常加载，返回false不加载
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(redirectURL) {
            //继续加载
            return true
        }
        
        //判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            //授权成功
            print("授权成功")
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            print(code)
            
            //利用已经授权的requestToken 换取ACCESS token
            loadAccessToken(code!)
        }else{
            //取消授权
            print("取消授权")
            selfClose()
        }
        
        return false
        
    }
    
    private func loadAccessToken(code:String){
        //定义路径
        let path = "oauth2/access_token"
        //封装参数
        let params = ["client_id":appKey, "client_secret":appSecret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirectURL]
        //发送post请求
        JKNetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) in
            print(JSON)
            
            let account = JKUserAccount(dict: JSON  as! [String : AnyObject])
            
            print(account)
            
            //获取用户信息
            account.loadUserInfo { (account, error) -> () in
                if account != nil
                {
                    account!.saveAccount()
                }
                
                SVProgressHUD.showInfoWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Black)
            }
            
            //归档模型
            //account.saveAccount()
            
        }) { (_, error) in
                print(error)
        }
        
    }
    
    //增加加载和加载完毕的指示器
    func webViewDidStartLoad(webView: UIWebView)
    {
        SVProgressHUD.showWithStatus("加载中，请稍后")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}

//"access_token" = "2.00xPlbPBhaMMDD606d263eb1EqeCJC";
//"expires_in" = 157679999;
//"remind_in" = 157679999;
//uid = 1146777665;

