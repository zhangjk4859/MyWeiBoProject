//
//  JKPhotoSelectorVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

private let JKPhotoSelectorCellReuseIdentifier = "JKPhotoSelectorCellReuseIdentifier"

class JKPhotoSelectorVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置子视图
        setupUI()
    }
    
    private func setupUI()
    {
        // 添加子控件
        view.addSubview(collcetionView)
        
        // 布局子控件
        collcetionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        view.addConstraints(cons)
        
    }
    // MARK: - 懒加载
    private lazy var collcetionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoSelectorViewLayout())
        clv.registerClass(PhotoSelectorCell.self, forCellWithReuseIdentifier: JKPhotoSelectorCellReuseIdentifier)
        clv.dataSource = self
        return clv
    }()
    
    lazy var pictureImages = [UIImage]()
    
}

extension JKPhotoSelectorVC: UICollectionViewDataSource, PhotoSelectorCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collcetionView.dequeueReusableCellWithReuseIdentifier(JKPhotoSelectorCellReuseIdentifier, forIndexPath: indexPath) as! PhotoSelectorCell
        
        cell.PhotoCellDelegate = self
        cell.backgroundColor = UIColor.greenColor()
        
        
        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item] // 0  1
        
        return cell
    }
    
    func photoDidAddSelector(cell: PhotoSelectorCell) {
        
        // 1.判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.PhotoLibrary)
        {
            print("不能打开相册")
            return
        }
        
        // 2.创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self
    
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
       
        print(image)
        
        let newImage = image.imageWithScale(300)
        
        
        // 1.将当前选中的图片添加到数组中
        pictureImages.append(newImage)
        collcetionView.reloadData()
        
        
        // 关闭图片选择器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoDidRemoveSelector(cell: PhotoSelectorCell) {
        
        
        // 1.从数组中移除"当前点击"的图片
        let indexPath = collcetionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        // 2.刷新表格
        collcetionView.reloadData()
    }
}

@objc
protocol PhotoSelectorCellDelegate : NSObjectProtocol
{
    optional func photoDidAddSelector(cell: PhotoSelectorCell)
    optional func photoDidRemoveSelector(cell: PhotoSelectorCell)
}

class PhotoSelectorCell: UICollectionViewCell {
    
    weak var PhotoCellDelegate: PhotoSelectorCellDelegate?
    
    var image: UIImage?
        {
        didSet{
            if image != nil{
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            }else
            {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        
        // 2.布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        contentView.addConstraints(cons)
    }
    
    // MARK: - 懒加载
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy  var addButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func addBtnClick()
    {
        
        PhotoCellDelegate?.photoDidAddSelector!(self)
    }
    
    func removeBtnClick()
    {
        
        PhotoCellDelegate?.photoDidRemoveSelector!(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoSelectorViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = CGSize(width: 80, height: 80)
        minimumInteritemSpacing  = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}

