//
//  JKWelcomVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/9.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SDWebImage

class JKWelcomVC: UIViewController {
    
    /// 记录底部约束
    var bottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.添加子控件
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2.布局子控件
        bgIV.jk_Fill(view)
        
        let cons = iconView.jk_AlignInner(type: JK_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -150))
        // 拿到头像的底部约束
        bottomCons = iconView.jk_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        messageLabel.jk_AlignVertical(type: JK_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
        
        // 3.设置用户头像
        if let iconUrl = JKUserAccount.loadAccount()?.avatar_large
        {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  bottomCons!.constant
        print(-UIScreen.mainScreen().bounds.height)
        print(bottomCons!.constant)
        // -736.0 + 586.0 = -150.0
        print(-UIScreen.mainScreen().bounds.height -  bottomCons!.constant)
        
        // 3.执行动画
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 头像动画
            self.iconView.layoutIfNeeded()
        }) { (_) -> Void in
            
            // 文本动画
            UIView.animateWithDuration( 10.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                self.messageLabel.alpha = 1.0
                }, completion: { (_) -> Void in
                   // print("OK")
                    // 去主页
                    NSNotificationCenter.defaultCenter().postNotificationName(JKSwitchRootVCNotification, object: true)
                    //test
            })
        }
        
    }
    
    // MARK: -懒加载
    private lazy var bgIV: UIImageView = UIImageView(image: UIImage(named:"ad_background"))
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.redColor()
        return iv
    }()
//    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named:"avatar_default_big"))
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
}
