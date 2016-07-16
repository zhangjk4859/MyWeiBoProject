//
//  JKStatusHeaderView.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/16.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKStatusHeaderView: UIView {

    var status: JKStatus?
        {
        didSet{
            // 设置昵称
            nameLabel.text = status?.user?.name
            // 设置用户头像
            if let url = status?.user?.imageURL
            {
                iconView.sd_setImageWithURL(url)
            }
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage
            // 设置会员图标
            print("mbrankImage = \(status?.user?.mbrankImage)")
            vipView.image = status?.user?.mbrankImage
            // 设置来源
            sourceLabel.text = status?.source
            // 设置时间
            timeLabel.text = status?.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2.布局子控件
        iconView.jk_AlignInner(type: JK_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.jk_AlignInner(type: JK_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.jk_AlignHorizontal(type: JK_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.jk_AlignHorizontal(type: JK_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.jk_AlignHorizontal(type: JK_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.jk_AlignHorizontal(type: JK_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView =
        {
            let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
            return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}
