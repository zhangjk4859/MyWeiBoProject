//
//  JKHomeCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

let JKPictureViewCellReuseIdentifier = "JKPictureViewCellReuseIdentifier"

class JKHomeCell: UITableViewCell {
    
    // 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    // 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    
    var status: JKStatus?
        {
        didSet{
            
            // 设置顶部视图
            topView.status = status
            
            // 设置正文
            contentLabel.text = status?.text
            
            // 设置配图的尺寸
            pictureView.status = status
            // 1.1根据模型计算配图的尺寸
            // 注意: 计算尺寸需要用到模型, 所以必须先传递模型
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            
        }
    }
    
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化UI
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        let width = UIScreen.mainScreen().bounds.width
        // 2.布局子控件
        topView.jk_AlignInner(type: JK_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        let cons = pictureView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        footerView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
    }
    
    /**
     用于获取行号
     */
    func rowHeight(status: JKStatus) -> CGFloat
    {
        // 1.为了能够调用didSet, 计算配图的高度
        self.status = status
        
        // 2.强制更新界面
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y值
        return CGRectGetMaxY(footerView.frame)
    }
    
    // MARK: - 懒加载
    // 顶部视图
    private lazy var topView: JKStatusHeaderView = JKStatusHeaderView()
    
    // 正文
    private lazy var contentLabel: UILabel =
        {
            let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
            return label
    }()
    
    // 配图
    private lazy var pictureView: JKStatusPictureView = JKStatusPictureView()
    
    // 底部工具条
    private lazy var footerView: JKStatusBottomView = JKStatusBottomView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


