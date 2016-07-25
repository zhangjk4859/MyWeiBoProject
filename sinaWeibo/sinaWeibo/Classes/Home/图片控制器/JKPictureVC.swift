//
//  JKPictureVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit
import SVProgressHUD

//定义重用标识符
private let photoBrowserCellReuseIdentifier = "pictureCell"

class JKPictureVC: UIViewController {

    //变量
    var currentIndex: Int?
    var pictureURLs: [NSURL]?
    
    //初始化
    init(index: Int, urls: [NSURL])
    {
        // Swift必须先初始化自身属性, 再初始化父类
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    //视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        // 初始化UI
        setupUI()
    }
    
    //设置自定义属性
    private func setupUI(){
        
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.布局子控件
        closeBtn.jk_AlignInner(type: JK_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 10, y: -10))
        saveBtn.jk_AlignInner(type: JK_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: -10, y: -10))
        collectionView.frame = UIScreen.mainScreen().bounds
        
        // 3.设置数据源
        collectionView.dataSource = self
        collectionView.registerClass(JKPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save()
    {
        // 1.拿到当前正在显示的cell
        let index = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(index) as! JKPhotoBrowserCell
        // 2.保存图片
        let image = cell.iconView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(JKPictureVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    }
    func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject){
        if error != nil
        {
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
        }else
        {
            SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    
    // MARK: - 懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: #selector(JKPictureVC.close), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: #selector(JKPictureVC.save), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
}

extension JKPictureVC : UICollectionViewDataSource, PhotoBrowserCellDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! JKPhotoBrowserCell
        
        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = pictureURLs![indexPath.item]
        cell.photoBrowserCellDelegate = self
        
        return cell
    }
    
    func photoBrowserCellDidClose(cell: JKPhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class PhotoBrowserLayout : UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces =  false
    }
}
