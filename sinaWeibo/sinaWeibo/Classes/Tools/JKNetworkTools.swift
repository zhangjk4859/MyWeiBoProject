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
    
    //封装网络方法，降低耦合性
    func sendStatus(text: String, image: UIImage?, successCallback: (status: JKStatus)->(), errorCallback: (error: NSError)->())
    {
        var path = "2/statuses/"
        let params = ["access_token":JKUserAccount.loadAccount()!.access_token! , "status": text]
        if image != nil
        {
            // 发送图片微博
            path += "upload.json"
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
    
                let data = UIImagePNGRepresentation(image!)!
                
                formData.appendPartWithFileData(data
                    , name:"pic", fileName:"abc.png", mimeType:"application/octet-stream");
                
                }, success: { (_, JSON) -> Void in
                    successCallback(status: JKStatus(dict: JSON as! [String : AnyObject]))
                }, failure: { (_, error) -> Void in
                    errorCallback(error: error)
            })
        }else
        {
            // 发送文字微博
            path += "update.json"
            POST(path, parameters: params, success: { (_, JSON) -> Void in
                successCallback(status: JKStatus(dict: JSON as! [String : AnyObject]))
            }) { (_, error) -> Void in
                errorCallback(error: error)
            }
        }
        
    }

    

}
