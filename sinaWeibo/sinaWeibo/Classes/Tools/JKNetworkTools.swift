//
//  JKNetworkTools.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import AFNetworking

//让类继承自AFmanager
class JKNetworkTools: AFHTTPSessionManager {
    
    //单例模式
    static let tools :JKNetworkTools = {
        
        let url = NSURL(string: "https://api.weibo.com/")
        let t = JKNetworkTools(baseURL: url)
        //设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return t
    }()
    
    //获取单例的方法 (类方法)
   class func shareNetworkTools() -> JKNetworkTools{
        return tools
    }

}
