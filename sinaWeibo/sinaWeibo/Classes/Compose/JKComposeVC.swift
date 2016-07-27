//
//  JKComposeVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SVProgressHUD

class JKComposeVC: UIViewController {
    // 表情键盘
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        self.textView.insertEmoticon(emoticon)
    }
    // 图片选择器
    private lazy var photoSelectorVC: JKPhotoSelectorVC = JKPhotoSelectorVC()
    
    // 工具条底部约束
    var toolbarBottonCons: NSLayoutConstraint?
    // 图片选择器高度约束
    var photoViewHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(JKComposeVC.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 将键盘控制器添加为当前控制器的子控制器
        addChildViewController(emoticonVC)
        addChildViewController(photoSelectorVC)
        
        // 初始化导航条
        setupNav()
        // 初始化输入框
        setupInpuView()
        // 初始化图片选择器
        setupPhotoView()
        // 初始化工具条
        setupToolbar()
    }
    
    /**
     只要键盘改变就会调用
     */
    func keyboardChange(notify: NSNotification)
    {
        print(notify)
        // 1.取出键盘rect
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        // 2.修改工具条的约束
        
        let height = UIScreen.mainScreen().bounds.height
        toolbarBottonCons?.constant = -(height - rect.origin.y)
        
        // 3.更新界面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        
        
        // 1.取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            // 2.设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }
        
        let anim = toolbar.layer.animationForKey("position")
        print("duration = \(anim?.duration)")
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoViewHeightCons?.constant == 0
        {
            // 主动召唤键盘
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 主动隐藏键盘
        textView.resignFirstResponder()
    }
    
    
    private func setupToolbar()
    {
        // 1.添加子控件
        view.addSubview(toolbar)
        view.addSubview(tipLabel)
        
        // 2.添加按钮
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            
                            ["imageName": "compose_mentionbutton_background"],
                            
                            ["imageName": "compose_trendbutton_background"],
                            
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings
        {
            
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            //let item = UIBarButtonItem(
            
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        
        // 3布局toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.jk_AlignInner(type: JK_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolbarBottonCons = toolbar.jk_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        //        tipLabel.text = "140"
        tipLabel.jk_AlignVertical(type: JK_AlignType.TopRight, referView: toolbar, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    
     //选择相片
    func selectPicture()
    {
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.调整图片选择器的高度
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    
    func setupPhotoView()
    {
        // 1.添加图片选择器
        view.insertSubview(photoSelectorVC.view, belowSubview: toolbar)
        
        // 2.布局图片选择器
        let size = UIScreen.mainScreen().bounds.size
        let widht = size.width
        let height: CGFloat = 0
        let cons = photoSelectorVC.view.jk_AlignInner(type: JK_AlignType.BottomLeft, referView: view, size: CGSize(width: widht, height: height))
        photoViewHeightCons = photoSelectorVC.view.jk_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    
     //切换表情键盘
    func inputEmoticon()
    {
       
        
        // 关闭键盘
        textView.resignFirstResponder()
        
        // 设置inputView
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        
        // 从新召唤出键盘
        textView.becomeFirstResponder()
    }
    
    
     //初始化输入视图
 
    private func setupInpuView()
    {
        // 添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 布局子控件
        textView.jk_Fill(view)
        placeholderLabel.jk_AlignInner(type: JK_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    
     //初始化导航条
 
    private func setupNav()
    {
        // 添加左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(JKComposeVC.close))
        
        // 添加右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(JKComposeVC.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "发送微博"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = JKUserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        label1.jk_AlignInner(type: JK_AlignType.TopCenter, referView: titleView, size: nil)
        label2.jk_AlignInner(type: JK_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    }
    
    
     //关闭控制器
 
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
     //发送文本微博
 
    func sendStatus()
    {
        
        let text = textView.emoticonAttributedText()
        let image = photoSelectorVC.pictureImages.first
        JKNetworkTools.shareNetworkTools().sendStatus(text , image: image, successCallback: { (status) -> () in
            // 提示用户发送成功
            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            // 关闭发送界面
            self.close()
        }) { (error) -> () in
            print(error)
            // 提示用户发送失败
            SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
        }
        
    }
    
    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(20)
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享你的小秘密"
        return label
    }()
    
    private lazy var toolbar: UIToolbar = UIToolbar()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
}


private let maxTipLength = 10
extension JKComposeVC: UITextViewDelegate
{
    func textViewDidChange(textView: UITextView)
    {
       
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
    
        let count =  textView.emoticonAttributedText().characters.count
        let res = maxTipLength - count
        tipLabel.textColor = (res > 0) ? UIColor.darkGrayColor() : UIColor.redColor()
        tipLabel.text = res == maxTipLength ? "" : "\(res)"
    }
}

