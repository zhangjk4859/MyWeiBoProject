//
//  UILabel+Category.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/14.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit


extension UILabel{
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}