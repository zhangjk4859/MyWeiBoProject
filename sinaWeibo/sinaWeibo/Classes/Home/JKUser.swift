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
        {
        didSet{
            if let urlStr = profile_image_url
            {
                imageURL = NSURL(string: urlStr)
            }
        }
    }
    // 直接提供URL头像
    var imageURL: NSURL?
    
    // 时候是认证, true是, false不是
    var verified: Bool = false
    
    // 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1{
        didSet{
            switch verified_type
            {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    // 用户认证图片
    var verifiedImage: UIImage?
    
    // 会员等级
    var mbrank: Int = 0 //基本数据类型要初始化
        {
        didSet{
            if mbrank > 0 && mbrank < 7
            {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")//拼接图片名
            }
        }
    }
    var mbrankImage: UIImage?
    
    
    
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
