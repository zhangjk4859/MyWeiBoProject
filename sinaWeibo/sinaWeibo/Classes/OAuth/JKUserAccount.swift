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
class JKUserAccount: NSObject,NSCoding {//遵循NSCoding协议
    
    //通行许可证
    var access_token : String?
    //有效时间
    var expires_in: NSNumber?{
        didSet{
            // 根据过期的秒数, 生成真正地过期时间
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expires_Date)
        }
    }
    
    /// 保存用户过期时间
    var expires_Date: NSDate?
    //唯一ID
    var uid : String?
    
    // 用户头像地址（大图），180×180像素
    var avatar_large: String?
    // 用户昵称
    var screen_name: String?
    
    override init() {
        
    }
    
    init(dict:[String : AnyObject ]) {
        
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid", "expires_Date", "avatar_large", "screen_name"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    //获取用户信息
    func loadUserInfo(finished: (account: JKUserAccount?, error:NSError?)->())
    {
        
        assert(access_token != nil, "没有授权")
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        
        JKNetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            print(JSON)
            // 1.判断字典是否有值
            if let dict = JSON as? [String: AnyObject]
            {
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                // 保存用户信息
                //                self.saveAccount()
                finished(account: self, error: nil)
                return
            }
            
            finished(account: nil, error: nil)
            
        }) { (_, error) -> Void in
            print(error)
            
            finished(account: nil, error: error)
        }

        
    }
    
//    override var description: String{
//        //定义属性数组
//        let properties = ["access_token","expires_in","uid"]
//        //根据属性数组，转换为字典,把Value取出来
//        let dic = self.dictionaryWithValuesForKeys(properties)
//        
//        return "\(dic)"
//    }
    
    /**
     返回用户是否登录
     */
    class func userLogin() -> Bool
    {
        return JKUserAccount.loadAccount() != nil
    }
    
    
    //保存授权模型到本地文件
    static  let filePath = "account.plist".cacheDir()
    
    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: JKUserAccount.filePath)
    }
    
    //静态变量，类方法和对象方法都要调用
    static var account: JKUserAccount?
    
    //从本地读取二进制数据，转换成模型对象
    class func loadAccount() -> JKUserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil
        {
            return account
        }
        // 2.加载授权模型
        
        account =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? JKUserAccount
        //判断是否过期
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            // 已经过期
            return nil
        }
        return account
    }
    
    //MARK: - NSCoding
    //将对象写入文件中
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token,forKey: "access_token")
        aCoder.encodeObject(expires_in,forKey: "expires_in")
        aCoder.encodeObject(uid,forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        
    }
    
    //从文件中读取对象
    required init?(coder aDecoder:NSCoder){
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name")  as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")  as? String
        
    }
    

}
