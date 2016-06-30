//
//  JKQRCodeVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

class JKQRCodeVC: UIViewController {

    //关闭按钮点击事件
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
    
    dismissViewControllerAnimated(true, completion: nil)
    }


    @IBOutlet weak var customTabBar: UITabBar!
    override func viewDidLoad() {
        customTabBar.selectedItem = customTabBar.items![0]
    }
}
