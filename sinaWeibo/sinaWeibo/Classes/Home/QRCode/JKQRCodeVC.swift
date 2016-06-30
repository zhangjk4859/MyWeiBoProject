//
//  JKQRCodeVC.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 6/30/16.
//  Copyright © 2016 张俊凯. All rights reserved.
//

import UIKit
import AVFoundation

class JKQRCodeVC: UIViewController,UITabBarDelegate {

    //容器视图高度
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    //底部tabbar
    @IBOutlet weak var customTabBar: UITabBar!
    
    //关闭按钮点击事件
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
    
       dismissViewControllerAnimated(true, completion: nil)
    }

   

    
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       //开始动画
        startAnimation()
        
        //开始扫描
        startScan()
    }
    
    
    //开始扫描
    func startScan(){
        //判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //判断是否能够将输出添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        
        //将输入和输出都添加到会话中
        session.addInput(deviceInput)
        print(output.availableMetadataObjectTypes)
        session.addOutput(output)
        print(output.availableMetadataObjectTypes)
        
        //设置输出能够解析的数据类型
        //一定要在输出对象添加到会员之后设置，否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        //设置输出对象的代理，只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex:0)
        
        //将绘制图层添加到预览图层上
        previewLayer.addSublayer(drawLayer)
        
        //告诉session开始扫描
        session.startRunning()
        
    }
    
    func startAnimation(){
        //让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        self.scanLineView.layoutIfNeeded()
        
        //执行冲击波动画
        UIView.animateWithDuration(2.0,animations: { () -> Void in
            self.scanLineCons.constant = self.containerHeightCons.constant
            //设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //强制更新画面
            self.scanLineView.layoutIfNeeded()
        })
    }
    
    //MARK: - UITabBarDelagate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print(item.tag)
        if item.tag == 1 {
            self.containerHeightCons.constant = 300
        }else{
            self.containerHeightCons.constant = 150
        }
        
        //停止动画
        self.scanLineView.layer.removeAllAnimations()
        
        //重新开始动画
        startAnimation()
    }
    
    //MARK: - 懒加载 视频会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    //拿到输入设备
    private lazy var deviceInput : AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    //拿到输出对象
    private lazy var output : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    //创建用于绘制边线的图层
    private lazy var drawLayer : CALayer = {
        let layer = CALayer()
        
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}

extension JKQRCodeVC:AVCaptureMetadataOutputObjectsDelegate{
    //只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //清空图册
        clearConers()
        
        //获取到扫描的数据
        //注意要使用stingValue
        print(metadataObjects.last?.stringValue)
        messageLabel.text = metadataObjects.last?.stringValue
        messageLabel.sizeToFit()
        
        //获取扫描到的二维码位置
        for object in metadataObjects {
            
            //判断当前获取到的数据是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject {
                //将坐标转换成界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                
                //绘制图形
                drawConers(codeObject)
                
            }
        }
        
    }
    
    //绘制图形
    private func drawConers(codeObject:AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty {
            return
        }
        
        //创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        //创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index :Int = 0
        
        //从corner数组中取出第0个元素，将这个字典的xy赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        //移动到其他的点
        while index < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        
        //关闭路径
        path.closePath()
        //绘制路径
        layer.path = path.CGPath
        
        //将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
        
    }
    
    
    //用来清空边线
    private func clearConers(){
        //判断drawLayer上是否有其他图层
        if  drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        
        //移除所有子图层
        for sublayer in drawLayer.sublayers! {
            sublayer.removeFromSuperlayer()
        }
    }
    
    
}


