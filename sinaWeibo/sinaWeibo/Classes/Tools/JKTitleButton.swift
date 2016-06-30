//
//  JKTitleButton.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

class JKTitleButton: UIButton {

    
    //初始化里面设置自定义
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置标题颜色
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件 在父类布局完以后再进行自定义布局
    override func layoutSubviews() {
        super.layoutSubviews()
        //让按钮的标题在左边 图片在右边
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }
    
    
    
}
