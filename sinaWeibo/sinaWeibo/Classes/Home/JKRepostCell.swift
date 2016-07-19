//
//  JKRepostCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/17.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKRepostCell: JKHomeCell {
    
    override var status: JKStatus?
        {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ": " + text
        }
    }

    

    override func setupUI() {
        super.setupUI()
        
        // 1.添加子控件
        //        contentView.addSubview(forwardButton)
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        // 2.布局子控件
        
        // 2.1布局转发背景
        forwardButton.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.jk_AlignVertical(type: JK_AlignType.TopRight, referView: footerView, size: nil)
        
        // 2.2布局转发正文
        forwardLabel.text = "fjdskljflkdsjflksdjlkfdsjlfjdslfjlkds"
        forwardLabel.jk_AlignInner(type: JK_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 2.3重新调整转发配图的位置
        let cons = pictureView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    // MARK: - 懒加载
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()


}
