//
//  JKTabBarController.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKTabBarController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.orangeColor()
        
        //添加四个子视图
       addChildViewController(JKHomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(JKDiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(JKMessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(JKProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    
    
    //抽出来的方法统一建立子控制器
    private  func addChildViewController(childController: UIViewController,title:String,imageName:String)
    {
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        addChildViewController(nav)

    }
    


}
