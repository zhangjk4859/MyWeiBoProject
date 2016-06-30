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
    
    //默认没有展示
    var isPresent : Bool = false
    
}



//转场动画的代理
extension JKHomeTableViewController:UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    //告诉系统谁来负责转场动画
    //iOS8以后专门负责转场动画
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return JKPopoverPC(presentedViewController: presented, presentingViewController: presenting)
    }
    
    //动画弹出来以后会调用
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            //如果是展开
            if #available(iOS 8.0, *) {
                let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
                toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
                
                //将视图添加到容器上
                transitionContext.containerView()?.addSubview(toView)
                
                //设置锚点
                toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                
                //执行动画
                UIView.animateWithDuration(0.5, animations: {
                    //清空transform
                    toView.transform = CGAffineTransformIdentity
                }){(_) -> Void in
                    
                    transitionContext.completeTransition(true)
                    
                }

            } else {
                // Fallback on earlier versions
            }
            
        }else{//关闭的时候
            
            if #available(iOS 8.0, *) {
                let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
                
                UIView.animateWithDuration(0.2, animations: {
                    fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                    }, completion: { (_) -> Void in
                        //如果不写，可能回到导致一些未知错误
                        transitionContext.completeTransition(true)
                })
            } else {
                // Fallback on earlier versions
            }
            
            
            
        }
    }
    
}

