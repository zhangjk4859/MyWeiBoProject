//
//  JKStatusPictureView.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/16.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SDWebImage

class JKStatusPictureView: UICollectionView {
    
    var status: JKStatus?
        {
        didSet{
            // 1. 刷新表格
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    init()
    {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        //注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: JKPictureViewCellReuseIdentifier)
        
        //设置数据源
        dataSource = self
        delegate = self
        
        //设置cell之间的间隙
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        //设置配图的背景颜色
        backgroundColor = UIColor.darkGrayColor()
    }
    
    
    
     //计算图片尺寸
    func calculateImageSize() -> CGSize
    {
        //取出配图个数
        let count = status?.storedPicURLS?.count
        //如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        //如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 取出缓存的图片
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            
            pictureLayout.itemSize = image.size
            // 返回缓存图片的尺寸
            return image.size
        }
        // 如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 如果是其它(多张), 计算九宫格的大小
        // 计算列数
        let colNumber = 3
        // 计算行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                // 1.设置图片
                iconImageView.sd_setImageWithURL(imageURL!)
                // 2.判断是否需要显示gif图标 // GIF
                if (imageURL!.absoluteString as NSString).pathExtension.lowercaseString == "gif"
                {
                    gifImageView.hidden = false
                }
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
            contentView.addSubview(iconImageView)
            iconImageView.addSubview(gifImageView)
            
            // 2.布局子控件
            iconImageView.jk_Fill(contentView)
            gifImageView.jk_AlignInner(type: JK_AlignType.BottomRight, referView: iconImageView, size: nil)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView:UIImageView = UIImageView()
        private lazy var gifImageView: UIImageView = {
            let iv = UIImageView(image: UIImage(named: "avatar_vgirl"))
            iv.hidden = true
            return iv
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}



//选中图片的通知名称
let JKStatusPictureViewSelected = "JKStatusPictureViewSelected"
//当前选中图片的索引对应的key
let JKStatusPictureViewIndexKey = "JKStatusPictureViewIndexKey"
//需要展示的所有图片对应的key
let JKStatusPictureViewURLsKey = "JKStatusPictureViewURLsKey"


extension JKStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    //collectionView返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(JKPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        
        // 2.设置数据
        cell.imageURL = status?.storedPicURLS![indexPath.item]
        
        // 3.返回cell
        return cell
    }
    
    //图片点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        print(status?.storedLargePicURLS![indexPath.item])
        
        //选中就发送通知给主页控制器
        let info = [JKStatusPictureViewIndexKey : indexPath, JKStatusPictureViewURLsKey : status!.storedLargePicURLS!]
        NSNotificationCenter.defaultCenter().postNotificationName(JKStatusPictureViewSelected, object: self, userInfo: info)
    }
    
}
