//
//  JKUserAccount.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit


//"access_token" = "2.00xPlbPBhaMMDD606d263eb1EqeCJC";
//"expires_in" = 157679999;
//"remind_in" = 157679999;
//uid = 1146777665;

//
class JKUserAccount: NSObject {
    
    //通行许可证
    var access_token : String?
    //有效时间
    var expires_in : NSNumber?
    //唯一ID
    var uid : String?
    
    override init() {
        
    }
    
    init(dict:[String : AnyObject ]) {
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    override var description: String{
        //定义属性数组
        let properties = ["access_token","expires_in","uid"]
        //根据属性数组，转换为字典,把Value取出来
        let dic = self.dictionaryWithValuesForKeys(properties)
        
        return "\(dic)"
        
    }
    

}
