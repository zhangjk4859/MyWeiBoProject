//
//  JKSQLiteManager.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKSQLiteManager: NSObject {
    
    private static let manager: JKSQLiteManager = JKSQLiteManager()
    // 为了线程安全，用单例模式
    class func shareManager() -> JKSQLiteManager {
        return manager
    }
    
    var dbQueue: FMDatabaseQueue?
    
    
     //打开数据库
 
    func openDB(DBName: String)
    {
        // 1.根据传入的数据库名称拼接数据库路径
        let path = DBName.docDir()
        print(path)
        
        // 2.创建数据库对象
        
        dbQueue = FMDatabaseQueue(path: path)
        
        
        // 3.创建表
        creatTable()
    }
    
    private func creatTable()
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusId INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userId INTEGER, \n" +
            "createDate TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) \n" +
        "); \n"
        
        // 2.执行SQL语句
        dbQueue!.inDatabase { (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }
    

}
