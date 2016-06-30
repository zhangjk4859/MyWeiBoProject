//
//  JKQRCodeVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

class JKQRCodeVC: UIViewController,UITabBarDelegate {

    //容器视图高度
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    
    //关闭按钮点击事件
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
    
    dismissViewControllerAnimated(true, completion: nil)
    }


    @IBOutlet weak var customTabBar: UITabBar!
    override func viewDidLoad() {
         super.viewDidLoad()
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    func startAnimation(){
        //让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        self.scanLineView.layoutIfNeeded()
        
        //执行冲击波动画
        UIView.animateWithDuration(2.0,animations: { () -> Void in
            self.scanLineCons.constant = self.containerHeightCons.constant
            //设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //强制更新画面
            self.scanLineView.layoutIfNeeded()
        })
    }
    
    //MARK: - UITabBarDelagate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print(item.tag)
        if item.tag == 1 {
            self.containerHeightCons.constant = 300
        }else{
            self.containerHeightCons.constant = 150
        }
        
        //停止动画
        self.scanLineView.layer.removeAllAnimations()
        
        //重新开始动画
        startAnimation()
    }
}
