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
        window?.rootViewController = JKNewfeatureVC()
        window?.makeKeyAndVisible()
        
        return true
    }

   

}

