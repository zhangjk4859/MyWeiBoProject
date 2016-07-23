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
    
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(refreshView)
        
        // 2.布局子控件
        refreshView.jk_AlignInner(type: JK_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
        
        //添加KVO,监控位移
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    
    // 记录旋转监听
    private var rotationArrowFlag = false
    // 是否执行动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        // 过滤数据
        if frame.origin.y >= 0
        {
            return
        }
        
        // 判断是否已经触发刷新事件
        if refreshing && !loadingViewAnimFlag
        {
           
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingViewAnim()
            return
        }
        
        //让箭头在同一侧旋转，非360度转圈
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            rotationArrowFlag = false
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
            rotationArrowFlag = true
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }
    }
    
    //停止刷新 重写父类方法
    override func endRefreshing() {
        super.endRefreshing()
        
        // 关闭圈圈动画
        refreshView.stopLoadingViewAnim()
        
        // 复位圈圈动画标记
        loadingViewAnimFlag = false
    }

    
    // MARK: - 懒加载
    private lazy var refreshView : JKHomeRefreshView =  JKHomeRefreshView.refreshView()
    
    //销毁的时候移除KVO监控
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }
    
    //必须自带
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JKHomeRefreshView: UIView
{
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    @IBOutlet weak var arrowIcon: UIImageView!
    
    
    /**
     旋转箭头
     */
    func rotaionArrowIcon(flag: Bool)
    {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    //转圈加载
    func startLoadingViewAnim()
    {
        tipView.hidden = true
        
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 执行完毕移除
        anim.removedOnCompletion = false
        // 动画添加图层
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    //停止加载转圈动画
    func stopLoadingViewAnim()
    {
        tipView.hidden = false
        
        loadingView.layer.removeAllAnimations()
    }

    
    
    class func refreshView() -> JKHomeRefreshView
    {
        return NSBundle.mainBundle().loadNibNamed("JKHomeRefreshView", owner: nil, options: nil).last as! JKHomeRefreshView
    }
}
