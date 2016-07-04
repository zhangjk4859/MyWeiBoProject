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
        let tools = JKNetworkTools(
        
        
    }()

}
