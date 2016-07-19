//
//  JKHomeTableViewController.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/6/5.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SVProgressHUD

let JKHomeReuseIdentifier = "JKHomeReuseIdentifier"

class JKHomeTableViewController: JKBaseViewController
{
    // 保存tableView数据
    var statuses: [JKStatus]?
        {
        didSet{
            // 有了数据就刷新表格
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitView?.setupVisitInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNav()
        
        //注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(change), name: animatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(change), name: animatorWillDismiss, object: nil)
        
        // 注册两个cell
        tableView.registerClass(JKNormalCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(JKRepostCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.RepostCell.rawValue)
        
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 4.加载微博数据
        loadData()
        
        
        
    }
    
    /**
     获取微博数据
     */
    private func loadData()
    {
        JKStatus.loadStatuses { (models, error) -> () in
            
            if error != nil
            {
                return
            }
            self.statuses = models
        }
    }

    
    
    //从自身移除通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //修改标题状态
    func change(){
        let titleBtn = navigationItem.titleView as! JKTitleButton
        titleBtn.selected = !titleBtn.selected
        
    }

    
    //自定义导航栏
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(JKHomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(JKHomeTableViewController.rightItemClick))
        //顶部按钮
        let titleBtn = JKTitleButton()
        titleBtn.setTitle("首页", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action:#selector(JKHomeTableViewController.titleBtnClick(_:)) , forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    //顶部标题按钮点击事件
    func titleBtnClick(btn:JKTitleButton){
        btn.selected = !btn.selected
        
        //来添加点击事件
        let sb = UIStoryboard(name:"JKPopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor.redColor()
        
        
        //自定义转场，不会移除以前的控制器的view
        vc?.transitioningDelegate = popoverAnimator
        
        // 设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
        
    }
    //注册按钮
    func leftItemClick(){
        print(#function)
    }
    //登录按钮
    func rightItemClick(){
        print(#function)
        //先从storyboard里面取出来控制器
        let sb = UIStoryboard(name: "JKQRCodeVC", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //弹出二维码控制器
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    


    //用来保存弹出二维码界面的代码
    func test(){
        //先从storyboard里面取出来控制器
        let sb = UIStoryboard(name: "JKQRCodeVC", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        //弹出二维码控制器
        presentViewController(vc!, animated: true, completion: nil)
    }
    
  
    //默认没有展示
    var isPresent : Bool = false
    
    
    //定义一个属性来自定义转场对象，否则会报错
    private lazy var popoverAnimator : JKPopoverAnimator = {
        let pa = JKPopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
    
    // 每一行的高度缓存起来
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
    
}


extension JKHomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    
    //每行显示什么内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! JKHomeCell
        // 2.设置数据
        cell.status = status
        
        // 3.返回cell
        return cell
    }
    
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.取出对应行的模型
        let status = statuses![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id]
        {
            return height
        }
        
        // 3.拿到cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! JKHomeCell
        
        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
        
        // 6.返回行高
        return rowHeight
    }

    
}




