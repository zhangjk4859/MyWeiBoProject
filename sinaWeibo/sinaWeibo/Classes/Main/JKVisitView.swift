//
//  JKVisitView.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/28.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKVisitView: UIView {

    //初始化里面布局子控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        //设置背景
        iconView.jk_AlignInner(type: JK_AlignType.Center, referView: self, size: nil)
        //设置小房子
        homeIcon.jk_AlignInner(type: JK_AlignType.Center, referView: self, size: nil)
        //设置文本
        messageLabel.jk_AlignVertical(type: JK_AlignType.BottomCenter, referView: iconView, size: nil)

        let widthCons = NSLayoutConstraint(item: messageLabel,attribute: NSLayoutAttribute.Width,relatedBy: NSLayoutRelation.Equal,toItem:nil,attribute:NSLayoutAttribute.NotAnAttribute,multiplier:1.0,constant:224)
        addConstraint(widthCons)
        
        //设置注册按钮
         registerBtn.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30),offset: CGPoint(x: 0, y: 20))
        //设置登录按钮
        loginBtn.jk_AlignVertical(type:JK_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30),offset: CGPoint(x: 0, y: 20))
        
        //设置蒙板
       // mask
        maskBGView.jk_Fill(self)
        
        
    }
    
    //定义一个控件，要么是纯代码，要么是xib
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //懒加载控件
    //转盘
    private lazy var iconView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
        return imageView
    }()
    
    //图标
    private lazy var homeIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))
        return imageView
    }()
    
    //文本
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "测试测试测试测试测试测试测试测试测试"
        return label
    }()
    
    //登录按钮
    private lazy var loginBtn:UIButton = {
       let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState())
        btn.setTitle("登录", forState: UIControlState())
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState())
        
        return btn
    }()
    
    //注册按钮
    private lazy var registerBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState())
        btn.setTitle("注册", forState: UIControlState())
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState())
        return btn
    }()
    
    //背景图
    private lazy var maskBGView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
        return imageView
    }()

}
