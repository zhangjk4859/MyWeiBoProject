//
//  NSDate+Category.swift
//  sinaWeibo
//
//  Created by 张俊凯 on 16/7/14.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

import UIKit


extension NSDate
{
    //把传进来的字符串转换成日期
    class func dateWithStr(time: String) ->NSDate {
        
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        
        formatter.locale = NSLocale(localeIdentifier: "en")
        let createdDate = formatter.dateFromString(time)!
        
        return createdDate
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    
    //把创建日期和当前日期进行比较
    var descDate:String{
        
        let calendar = NSCalendar.currentCalendar()
        
       
        if calendar.isDateInToday(self)
        {
            
            let since = Int(NSDate().timeIntervalSinceDate(self))
            
            if since < 60
            {
                return "刚刚"
            }
            
            if since < 60 * 60
            {
                return "\(since/60)分钟前"
            }
            
           
            return "\(since / (60 * 60))小时前"
        }
        
        
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self)
        {
            
            formatterStr =  "昨天:" +  formatterStr
        }else
        {
            
            formatterStr = "MM-dd " + formatterStr
            
            
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1
            {
                formatterStr = "yyyy-" + formatterStr
            }
        }
        
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = formatterStr
       
        formatter.locale = NSLocale(localeIdentifier: "en")

        return formatter.stringFromDate(self)
    }
}
