//
//  JKPopoverAnimator.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

// 定义常量保存通知的名称
let animatorWillShow = "JKAnimatorWillShow"
let animatorWillDismiss = "animatorWillDismiss"


class JKPopoverAnimator: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    //记录当前是否展开
    var isPresent:Bool = false
    //定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    //实现代理方法，告诉系统谁来负责转场动画
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = JKPopoverPC(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        
        return pc
        
    }
    
    
    //动画弹出来以后会调用
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName(animatorWillShow, object: nil)
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        //发送通知，即将消失
        NSNotificationCenter.defaultCenter().postNotificationName(animatorWillDismiss, object: nil)
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
                
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: {(_) -> Void in
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
