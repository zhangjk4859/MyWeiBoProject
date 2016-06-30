//
//  JKHomeTableViewController.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKHomeTableViewController: JKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitView?.setupVisitInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        
        setupNav()
    }

    
    //自定义导航栏
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(JKHomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(JKHomeTableViewController.rightItemClick))
        //顶部按钮
        let titleBtn = JKTitleButton()
        titleBtn.setTitle("张俊凯", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action:#selector(JKHomeTableViewController.titleBtnClick(_:)) , forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    //顶部标题按钮点击事件
    func titleBtnClick(btn:JKTitleButton){
        btn.selected = !btn.selected
        
        //来添加点击事件
        let sb = UIStoryboard(name:"JKPopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor.redColor()
        
        
        //自定义转场，不会移除以前的控制器的view
        vc?.transitioningDelegate = self
        
        // 设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
        
    }
    
    func leftItemClick(){
        print(#function)
    }
    
    func rightItemClick(){
        print(#function)
    }
    

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}



//转场动画的代理
extension JKHomeTableViewController:UIViewControllerTransitioningDelegate{
    //告诉系统谁来负责转场动画
    //iOS8以后专门负责转场动画
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return JKPopoverPC(presentedViewController: presented, presentingViewController: presenting)
    }
}

