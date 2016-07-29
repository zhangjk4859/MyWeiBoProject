//
//  JKRepostCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/17.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import KILabel

class JKRepostCell: JKHomeCell {
    
    

    override var status: JKStatus?
        {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            
            forwardLabel.attributedText = EmoticonPackage.emoticonString("@" + name + ": " + text)
        }
    }
    //父类的设置子视图方法，重写
    override func setupUI() {
        super.setupUI()
        
        //1.添加子控件
        //1.1按钮在配图下面
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        //1.2正文在按钮上面
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        // 2.布局子控件
        
        // 2.1布局转发背景
        forwardButton.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.jk_AlignVertical(type: JK_AlignType.TopRight, referView: footerView, size: nil)
        
        // 2.2布局转发正文
        forwardLabel.text = "fjdskljflkdsjflksdjlkfdsjlfjdslfjlkds"
        forwardLabel.jk_AlignInner(type: JK_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 2.3重新调整转发配图的位置，配图放到转发的正文下面
        let cons = pictureView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 10))

        
        pictureWidthCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    // MARK: - 懒加载
    //转发内容label显示正文
//    private lazy var forwardLabel: UILabel = {
//        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
//        label.numberOfLines = 0
//        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
//        return label
//    }()
    //可以实现label内容点击网页链接和高亮
    private lazy var forwardLabel: UILabel = {
                    let label = KILabel()
                    label.textColor = UIColor.darkGrayColor()
                    label.font = UIFont.systemFontOfSize(15)
                    label.numberOfLines = 0
                    label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        
                    // 监听URL
                    label.urlLinkTapHandler =  {
                        (label, string, range)
                        in
                        
                       
//                    //只能调用类方法，静态方法
//                    JKRepostCell.openWebView(string)
                        
                    }
                    
                    return label
    }()
    
    //找view的所在控制器
    func parentViewController() -> UIViewController?
    {
        for (let next = self.superview; next != nil; next?.superview) {
            let ctr = next?.nextResponder()
            if (ctr is UIViewController)
            {
                return ctr as? UIViewController
            }
        }
        return nil
    }
    
    //接受KILabel的字符串，弹出控制器
   func openWebView(string : String)
   {
    
    let vc = parentViewController()
    let webVC = JKWelcomVC()
    
    vc?.navigationController?.pushViewController(webVC, animated: true)

    }
    
    
    
    //整个cell是一个button，可以点击
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()

    
}
