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
    
    //保存授权模型到本地文件
    func saveAccount(){
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath\(filePath)")
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    //从本地读取二进制数据，转换成模型对象
    class func loadAccount() -> JKUserAccount? {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath \(filePath)")
        
        let account =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? JKUserAccount
        return account
    }
    
    //MARK: - NSCoding
    //将对象写入文件中
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token,forKey: "access_token")
        aCoder.encodeObject(expires_in,forKey: "expires_in")
        aCoder.encodeObject(uid,forKey: "uid")
        
    }
    
    //从文件中读取对象
    required init?(coder aDecoder:NSCoder){
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        
    }
    

}
