//
//  AppDelegate.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

// 切换控制器通知
let JKSwitchRootVCNotification = "SwitchRootVCNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //1.程序启动时启动数据库，用来缓存微博
        JKSQLiteManager.shareManager().openDB("status.sqlite")
        
        //程序一进来就设置全局外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        //window?.rootViewController = JKTabBarController()
        //window?.rootViewController = JKNewfeatureVC()
        window?.rootViewController = JKWelcomVC()
        
        window?.makeKeyAndVisible()
        
        print(isNewupdate())
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootVC), name: JKSwitchRootVCNotification, object: nil)
        
        
        
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //切换根控制器
    func switchRootVC(notify: NSNotification)
    {
        
        if notify.object as! Bool
        {
            window?.rootViewController = JKTabBarController()
        }else
        {
            window?.rootViewController = JKWelcomVC()
        }
    }
    
    

    private func isNewupdate() -> Bool{
        // 获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 获取老版本
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 开始比较
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // iOS7以后就不用调用同步方法了
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        // 3.2如果当前< | ==  --> 没有新版本
        return false
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        print(#function)
        // 进入后台以后，清除一分钟以前缓存的数据
        JKStatusDAO.cleanStatuses()
    }
}

