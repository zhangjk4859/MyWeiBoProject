//
//  AppDelegate.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //程序一进来就设置全局外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        //window?.rootViewController = JKTabBarController()
        //window?.rootViewController = JKNewfeatureVC()
        window?.rootViewController = JKWelcomVC()
        
        window?.makeKeyAndVisible()
        
        return true
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

   

}

