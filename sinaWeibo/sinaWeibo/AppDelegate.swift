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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame:UIScreen.main().bounds)
        window?.backgroundColor = UIColor.white()
        window?.rootViewController = JKTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

   

}

