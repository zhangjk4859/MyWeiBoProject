//
//  JKHomeRefreshControl.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKHomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(refreshView)
        
        // 2.布局子控件
        refreshView.jk_AlignInner(type: JK_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
    }
    
    // MARK: - 懒加载
    private lazy var refreshView : JKHomeRefreshView =  JKHomeRefreshView.refreshView()
    
    
    
}

class JKHomeRefreshView: UIView
{
    class func refreshView() -> JKHomeRefreshView
    {
        return NSBundle.mainBundle().loadNibNamed("JKHomeRefreshView", owner: nil, options: nil).last as! JKHomeRefreshView
    }
}
