//
//  JKHomeCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

import KILabel

//图片视图类cell的重用标识
let JKPictureViewCellReuseIdentifier = "JKPictureViewCellReuseIdentifier"

enum StatusTableViewCellIdentifier: String
{
    case NormalCell = "NormalCell"
    case RepostCell = "RepostCell"
    

    static func cellID(status: JKStatus) ->String
    {
        return status.retweeted_status != nil ? RepostCell.rawValue : NormalCell.rawValue
    }
}

class JKHomeCell: UITableViewCell {
    
    // 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    // 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    // 保存配图的顶部约束
    var pictureTopCons: NSLayoutConstraint?
    
    var status: JKStatus?
        {
        didSet{
            
            // 顶部视图设置数据
            topView.status = status
            
            // 内容
            //contentLabel.text = status?.text
            contentLabel.attributedText = EmoticonPackage.emoticonString(status?.text ?? "")
            
            // 设置配图的尺寸，注意有原创和转发的区别
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status :  status
           
           
            //设置图片尺寸
            let size = pictureView.calculateImageSize()
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
            
            
            
        }
    }
    
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化UI
        setupUI()
    }
    
     func setupUI()
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
    
    // 正文,公开属性
    lazy var contentLabel: KILabel =
        {
            
            let label = KILabel()
            label.textColor = UIColor.darkGrayColor()
            label.font = UIFont.systemFontOfSize(15)
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
            
            // 监听URL
            label.urlLinkTapHandler =  {
                (label, string, range)
                in
                print(string)
            }
            
            return label
    }()
    
    // 配图
     lazy var pictureView: JKStatusPictureView = JKStatusPictureView()
    
    // 底部工具条
     lazy var footerView: JKStatusBottomView = JKStatusBottomView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


