//
//  JKHomeCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/13.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKHomeCell: UITableViewCell {
    
    //模型设置为属性
    var status: JKStatus?
        {
        didSet{
            nameLabel.text = status?.user?.name
            
            timeLabel.text = "万历年间"
            sourceLabel.text = "来自: 星星的你"
            contentLabel.text = status?.text
            
            //设置用户头像
            if let url = status?.user?.imageURL
            {
                iconView.sd_setImageWithURL(url)
            }
        }
    }
    
    // 自定义子控件
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2.布局子控件
        iconView.jk_AlignInner(type: JK_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.jk_AlignInner(type: JK_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.jk_AlignHorizontal(type: JK_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.jk_AlignHorizontal(type: JK_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.jk_AlignHorizontal(type: JK_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.jk_AlignHorizontal(type: JK_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // 添加一个底部约束
        // TODO: 这个地方是又问题的
        //        contentLabel.jk_AlignInner(type: JK_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
        let width = UIScreen.mainScreen().bounds.width
        footerView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        footerView.jk_AlignInner(type: JK_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    
    // MARK: - 懒加载
    // 头像
    private lazy var iconView: UIImageView =
        {
            let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
            return iv
    }()
    // 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    // 昵称
    private lazy var nameLabel: UILabel = .createLabel(UIColor.darkGrayColor(), fontSize: 14)
    // 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    // 时间
    private lazy var timeLabel: UILabel = .createLabel(UIColor.darkGrayColor(), fontSize: 14)
    // 来源
    private lazy var sourceLabel: UILabel =
        .createLabel(UIColor.darkGrayColor(), fontSize: 14)
    // 正文
    private lazy var contentLabel: UILabel =
        {
            let label = UILabel()
            label.textColor = UIColor.darkGrayColor()
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(15)
            label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
            return label
    }()
    
    // 底部工具条
    private lazy var footerView: StatusFooterView = StatusFooterView()


}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 2.布局子控件
        jk_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载底部三个按钮
    // 转发
    private lazy var retweetBtn: UIButton = .createButton("timeline_icon_retweet", title: "转发")
    
    // 赞
    private lazy var unlikeBtn: UIButton = .createButton("timeline_icon_unlike", title: "赞")
    
    // 评论
    private lazy var commonBtn: UIButton = .createButton("timeline_icon_comment", title: "评论")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



