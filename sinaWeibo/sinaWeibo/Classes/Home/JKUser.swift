//
//  JKUser.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

//每一天微博数据里面对应的用户
class JKUser: NSObject
{
    
    // 用户ID
    var id: Int = 0
    // 友好显示名称
    var name: String?
    // 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    // 时候是认证, true是, false不是
    var verified: Bool = false
    // 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1
    
    // 字典转模型
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }


}
