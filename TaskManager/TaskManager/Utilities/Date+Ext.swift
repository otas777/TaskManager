//
//  Date+Ext.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/21.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

extension Date {
    
    static let defaultFormat = "yyyy/MM/dd HH:mm:ss"
    
    static var now: String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = defaultFormat
        return dateFormater.string(from: Date())
    }

    func toString(format: String = defaultFormat) -> String {
        let dateFormatter = DateFormatter()
        let cal = Calendar(identifier: .gregorian)
        dateFormatter.calendar = cal
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func fromString(dateString: String?, format: String = defaultFormat) -> Date? {
        guard let str = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        let cal = Calendar(identifier: .gregorian)
        dateFormatter.calendar = cal
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: str)
    }
    
    func isPassedNow(periodDay: Double = 0.0) -> Bool {
        
        // 時刻を23:59:59に変更してから経過時間を判定する
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let tmp = calendar.date(from: components)!
        
        let interval = tmp.timeIntervalSinceNow
        let elapsedDay = -(interval / 86400)
        print("isPassedNow periodDay:\(periodDay) \(elapsedDay)")
        return periodDay < elapsedDay
    }
    
    func afterDate(sec: TimeInterval) -> Date {
        return Date(timeInterval: sec, since: self)
    }
}
