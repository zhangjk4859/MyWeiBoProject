//
//  JKNewfeatureVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

//重用标识
private let reuseIdentifier = "reuseIdentifier"

class JKNewfeatureVC: UICollectionViewController {
    
    /// 页面个数
    private let  pageCount = 4
    /// 布局对象
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    
    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    //NewfeatureCell.self = [NewfeatureCell class]
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }





    // MARK: UICollectionViewDataSource
    // 几个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    // 返回对应indexPath的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        
        // 2.设置cell的数据
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 自定义的类
    private class NewfeatureCell: UICollectionViewCell
    {
       //在同一文件中，即使是private 也可以被访问
        private var imageIndex:Int? {
            didSet{
                iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // 1.初始化UI
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI(){
        
            contentView.addSubview(iconView)
            
            iconView.jk_Fill(contentView)
        }
        
        // MARK: - 懒加载
        private lazy var iconView = UIImageView()
    }
    
    private class NewfeatureLayout: UICollectionViewFlowLayout {
        
        
        override func prepareLayout()
        {
            // 1.设置layout布局，大小，间距，滚动方向
            itemSize = UIScreen.mainScreen().bounds.size
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            
            // 2.设置collectionView的属性
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.bounces = false
            collectionView?.pagingEnabled = true
        }
    }




}
