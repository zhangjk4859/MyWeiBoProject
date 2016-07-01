//
//  JKQRCodeCardVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit

class JKQRCodeCardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      navigationItem.title = "我的名片"
        //添加图片容器
        view.addSubview(iconView)
        
        //布局图片容器
        iconView.jk_AlignInner(type: JK_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        iconView.backgroundColor = UIColor.redColor()
        
        //生成二维码
        let qrcodeImage = creatQRCodeImage()
        
        //将生成好的二维码添加到图片容器上
        iconView.image = qrcodeImage
        
    }
    
    func creatQRCodeImage()->UIImage{
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //还原滤镜的默认属性
        filter?.setDefaults()
        
        //设置需要生成二维码的数据
        filter?.setValue("王钰瑾张俊凯".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        //从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        let bgImage = creatNonInterpolatedUIImageFromCIImage(ciImage!,size:300)
        
        //创建一个头像
        let icon = UIImage(named: "angry.jpg")
        
        //讲二维码和头像合并
        let newImage = creatImage(bgImage,iconImage:icon!)
        
        //返回合成好的image
        return newImage
        
    }

    private func creatImage(bgImage:UIImage,iconImage:UIImage) ->UIImage{
        //开启图形上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        //绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    private func creatNonInterpolatedUIImageFromCIImage(image:CIImage,size:CGFloat)->UIImage{
        
        let extent:CGRect = CGRectIntegral(image.extent)
        let scale:CGFloat = min(size/CGRectGetWidth(extent),size/CGRectGetHeight(extent))
        
        //创建bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage:CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        //保存bitmap到图片
        let scaleImage:CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaleImage)
        
    }
    

    //懒加载
    private lazy var iconView : UIImageView = UIImageView()



}
