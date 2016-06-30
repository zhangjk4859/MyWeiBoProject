//
//  JKHomeTableViewController.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKHomeTableViewController: JKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitView?.setupVisitInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        
        setupNav()
    }

    
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(JKHomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(JKHomeTableViewController.rightItemClick))
    }
    
    
    func leftItemClick(){
        print(#function)
    }
    
    func rightItemClick(){
        print(#function)
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
