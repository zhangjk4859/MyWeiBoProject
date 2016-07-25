//
//  JKPhotoBrowserCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/25.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserCellDidClose(cell: JKPhotoBrowserCell)
}

class JKPhotoBrowserCell: UICollectionViewCell {
    
    
    //代理设置弱属性
    weak var photoBrowserCellDelegate : PhotoBrowserCellDelegate?
    
    //图片链接
    var imageURL: NSURL?
        {
        didSet{
            // 重置属性
            reset()
            
            // 显示菊花
            activity.startAnimating()
            
            // 设置图片
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                // 隐藏菊花
                self.activity.stopAnimating()
                
                // 调整图片的尺寸和位置
                self.setImageViewPostion()
                
            }
        }
    }
    
     //重置scrollview和imageview的属性
    private func reset()
    {
        // 重置scrollview
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        
        // 重置imageview
        iconView.transform = CGAffineTransformIdentity
    }
    
    
    //调整图片显示的位置
    private func setImageViewPostion()
    {
        // 拿到按照宽高比计算之后的图片大小
        let size = self.displaySize(iconView.image!)
        // 判断图片的高度, 是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height
        {
            //图片居中显示
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            //处理居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }else
        {
            //设置scrollview的滚动范围为图片的大小
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        }
    }
    
    
     //按照图片的宽高比计算图片显示的大小
    private func displaySize(image: UIImage) -> CGSize
    {
        // 拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    private func setupUI()
    {
        // 添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        contentView.addSubview(activity)
        
        // 布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds
        activity.center = contentView.center
        
        // 处理缩放
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        // 监听图片的点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(JKPhotoBrowserCell.close))
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
        
        
    }
    
    
     //关闭浏览器
    func close()
    {
        print("close")
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
    lazy var iconView: UIImageView = UIImageView()
    private lazy var activity: UIActivityIndicatorView =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JKPhotoBrowserCell: UIScrollViewDelegate
{
    // 告诉系统需要缩放哪个控件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return iconView
    }
    
    // 重新调整配图的位置
    // view: 被缩放的视图
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5

        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
