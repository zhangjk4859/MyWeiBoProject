//
//  JKStatus.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SDWebImage


class JKStatus: NSObject
{
    
    //微博创建时间
    var created_at: String?
        {
        didSet{
            
            //将字符串转换为时间，经过处理后再转换成字符串
            let createdDate = NSDate.dateWithStr(created_at!)

            created_at = createdDate.descDate
        }
    }

    // 微博ID
    var id: Int = 0
    // 微博信息内容
    var text: String?
    // 微博来源
    var source: String?
        {
        didSet{
            // <a href=\"http://app.weibo.com/t/feed/4fuyNj\" rel=\"nofollow\">即刻笔记</a>
            print(source)
            // 1.截取字符串
            if source?.characters.count > 0
            {
                let str = source!

                // 1.1获取开始截取的位置
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                // 1.2获取截取的长度
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                // 1.3截取字符串
                source = "来自:" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
                print(source)
            }
        }
    }

    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
        {
        didSet{
            // 1.初始化数组
            storedPicURLS = [NSURL]()
            storedLargePicURLS = [NSURL]()
            
            // 2遍历取出所有的图片路径字符串
            for dict in pic_urls!
            {
                if let urlStr = dict["thumbnail_pic"] as? String
                {
                    // 1.将字符串转换为URL保存到数组中
                    storedPicURLS!.append(NSURL(string: urlStr)!)
                    
                    // 2.小图关键字替换成大图
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLS!.append(NSURL(string: largeURLStr)!)
                    
                }
            }
        }
    }
    // 保存当前微博所有配图的URL
    var storedPicURLS: [NSURL]?
    // 保存当前微博所有大图URL
    var storedLargePicURLS: [NSURL]?
    
    // 是否为转发微博
    var retweeted_status: JKStatus?
    
    // 用户信息
    var user: JKUser?
    
    // 加载微博数据,用blcok回调的方式
    class func loadStatuses(since_id: Int, max_id: Int,finished: (models:[JKStatus]?, error:NSError?)->()){
        
        JKStatusDAO.loadStatuses(since_id, max_id: max_id) { (array, error) -> () in
            
            if array == nil
            {
                finished(models: nil, error: error)
            }
            
            if error != nil
            {
                finished(models: nil, error: error)
            }
            
            // 2.遍历数组, 将字典转换为模型
            let models = dict2Model(array!)
            
            // 3.缓存微博配图
            cacheStatusImages(models, finished: finished)
        }
        
    }
    
    //类方法调用类方法,缓存图片
    class func cacheStatusImages(list: [JKStatus], finished: (models:[JKStatus]?, error:NSError?)->()) {
        
        // 1.创建一个组
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for status in list
        {
            for url in status.storedPicURLS!
            {
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                // 缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                    // 离开当前组
                    dispatch_group_leave(group)
                    
                })
            }
        }
        
        // 2.当所有图片都下载完毕再通过block通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
    
            //图片缓存完毕后再通知外界下载完毕
            finished(models: list, error: nil)
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
    
    // setValuesForKeysWithDictionary拦截方法，把用户信息填写进去
    override func setValue(value: AnyObject?, forKey key: String)
    {
        
        if "user" == key
        {
            // 2.根据user key对应的字典创建一个模型
            user = JKUser(dict: value as! [String : AnyObject])
            return
        }
        
        // 2.判断是否是转发微博, 如果是就自己处理
        if "retweeted_status" == key
        {
            retweeted_status = JKStatus(dict: value as! [String : AnyObject])
            return
        }
        
        // 3,调用父类方法, 按照系统默认处理
        super.setValue(value, forKey: key)
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
