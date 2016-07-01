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
    private lazy var webView : UIWebView = UIWebView()
    
}
