//
//  JKStatus.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKStatus: NSObject
{
    
    // 微博创建时间
    var created_at: String?
    // 微博ID
    var id: Int = 0
    // 微博信息内容
    var text: String?
    // 微博来源
    var source: String?
    // 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    /// 加载微博数据,用blcok回调的方式
    class func loadStatuses(finished: (models:[JKStatus]?, error:NSError?)->()){
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": JKUserAccount.loadAccount()!.access_token!]
        
        JKNetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            //            print(JSON)
            // 1.取出statuses key对应的数组 (存储的都是字典)
            // 2.遍历数组, 将字典转换为模型
            let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
            //            print(models)
            // 2.通过闭包将数据传递给调用者
            finished(models: models, error: nil)
            
        }) { (_, error) -> Void in
            print(error)
            finished(models: nil, error: error)
            
        }
    }
    
    
    // 将字典数组转换为模型数组
    class func dict2Model(list: [[String: AnyObject]]) -> [JKStatus] {
        var models = [JKStatus]()
        for dict in list
        {
            models.append(JKStatus(dict: dict))
        }
        return models
    }
    
    // 服务器返回来的字典转换成模型的属性
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //模型里没有属性的时候重写方法防止报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }


    

}
