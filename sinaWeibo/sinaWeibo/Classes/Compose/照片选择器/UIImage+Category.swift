//
//  UIImage+Category.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

extension UIImage
{
    //目的：压缩图片，减少内存占用
    func imageWithScale(width: CGFloat) -> UIImage
    {
        // 1.根据宽度计算高度
        let height = width *  size.height / size.width
        
        // 2.按照宽高比绘制一张新的图片
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}