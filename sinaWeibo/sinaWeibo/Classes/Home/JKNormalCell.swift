//
//  JKNormalCell.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/17.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class JKNormalCell: JKHomeCell {

    override func setupUI() {
        super.setupUI()
        
        let cons = pictureView.jk_AlignVertical(type: JK_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.jk_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }


}
