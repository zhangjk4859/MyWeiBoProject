//
//  JKOAuthVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 7/1/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

class JKOAuthVC: UIViewController {

    //定义常量区域
    let appKey = "2795635843"
    let appSecret = "14f44971d84942a6dea5c4effaf05a83"
    let redirectURL = "http://www.juziit.net/"
    
    
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
    //懒加载
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
        }else{
            //取消授权
            print("取消授权")
            selfClose()
        }
        
        return false
        
    }
    
}
