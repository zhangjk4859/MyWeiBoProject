//
//  JKPopoverPC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class JKPopoverPC: UIPresentationController {

    //正在呈现和已经呈现的吗？
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
       // print("presentedViewController",presentedViewController)
      //   print("presentingViewController",presentingViewController)
    }
    
    //动画即将出现的时候布局子视图
    override func containerViewWillLayoutSubviews() {
        //修改子视图的大小
        //containerView:容器视图
        //presentedView：被展现的视图
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        
        //在容器视图下面插入一个蒙板
        containerView?.insertSubview(bottomView, atIndex: 0)
    }
    
    
    // 懒加载底部蒙板视图
    private lazy var bottomView : UIView = {
        let view = UIView()
        
        //中间进行自定义
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        //添加监听手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(JKPopoverPC.close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close(){
        //让已经呈现的控制器消失
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
