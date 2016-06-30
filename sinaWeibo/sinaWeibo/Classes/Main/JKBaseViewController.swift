//
//  JKBaseViewController.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKBaseViewController: UITableViewController,VisitViewDelegate {

    //定义一个变量保存用户登录
    var userLogin = false
    
    //定义属性保存未登陆界面
    var visitView :JKVisitView?
    
    
    //加载视图的时候判断加载哪一个视图
    override func loadView() {
        userLogin ? super.loadView() : setupVisitView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .redColor()
        
    }

    
   private func setupVisitView() {
    
    //创建自定义视图并且赋值给属性
    let customView = JKVisitView()
    customView.delegate = self
    view = customView
    visitView = customView
    
    
    navigationController?.navigationBar.tintColor = UIColor.orangeColor()
    //设置导航栏未登陆按钮
    navigationItem.leftBarButtonItem = UIBarButtonItem(title:"注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(JKBaseViewController.registerBtnWillClick))
    

    //设置导航栏未登陆按钮
    navigationItem.rightBarButtonItem   = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(JKBaseViewController.loginBtnWillClick))
//
}


    //MARK: - visitViewDelagate
    //按钮点击的方法在这里实现
    //登陆按钮
    func loginBtnWillClick() {
        print(#function)
    }
    //注册按钮
    func registerBtnWillClick() {
        print(#function)
    }


}
