//
//  UIColor+Category.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/25.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

extension UIColor
{
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber() , alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        // 0 - 255
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}
