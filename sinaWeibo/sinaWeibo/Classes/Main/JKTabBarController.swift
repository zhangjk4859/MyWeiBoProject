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

        //设置字体的颜色
        tabBar.tintColor = UIColor.orangeColor()
        
        //获取文件路径
     let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        //转换成二进制数据,做一个判断
        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            
            do{
                //有可能发生异常的代码放到这里
                //try :发生异常会跳到catch里面继续执行
                //try！：发生异常程序直接崩溃
                let dicArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers)
               // print(dicArray)
                
                //swift中遍历数组，必须要明确数组的一个类型
                for dic in dicArray as![[String:String]]{
                    addChildViewController(dic["vcName"]!, title: dic["title"]!, imageName: dic["imageName"]!)
                }
                
                
            }catch{
                print(error)
                //如果失败，本地添加四个子视图
                addChildViewController("JKHomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("JKMessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("JKDiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("JKProfileTableViewController", title: "我", imageName: "tabbar_profile")

            }

            
        }//end for if

    }//end for viewDidLoad
    
    
    
    //抽出来的方法统一建立子控制器
    private  func addChildViewController(childControllerName: String,title:String,imageName:String)
    {
        //动态获取命名空间  两个叹号代表字典里一定有值，一定是字符串
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        //把字符串转换成一个类,必须是命名空间加一个点才能创建,创建出来的类，有可能有，有可能没有
        let cls:AnyClass? = NSClassFromString(nameSpace + "." + childControllerName)
        
        //将anyclass转换为指定的已知类型
        let vcCls = cls as! UIViewController.Type
        
        //再将class转换为对象
        let vc  = vcCls.init()
        
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        //包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        addChildViewController(nav)

    }
    


}
