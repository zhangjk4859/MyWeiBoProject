//
//  UIBarButtonItem+Category.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    //在func前面加上class，就是类方法，静态方法
    class func creatBarButtonItem(imageNamed:String,target:AnyObject?,action:Selector)->UIBarButtonItem{
        let button = UIButton()
        button.setImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageNamed + "_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
        
    }
    
    convenience init(imageName:String, target: AnyObject?, action: String?)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if action != nil
        {
            btn.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        btn.sizeToFit()
        self.init(customView: btn)
    }
    
}
