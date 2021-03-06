//
//  EmoticonTextAttachment.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    // 保存对应表情的文字
    var chs: String?
    
    /// 根据表情模型, 创建表情字符串
    class func imageText(emoticon: Emoticon, font: UIFont) -> NSAttributedString{
        
        // 1.创建附件
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 设置了附件的大小
        let s = font.lineHeight
        attachment.bounds = CGRectMake(0, -4, s, s)
        
        // 2. 根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}
