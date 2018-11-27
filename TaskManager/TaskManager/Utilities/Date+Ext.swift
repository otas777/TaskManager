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
    
    
    /// 現在の日付・時刻を取得
    static var now: String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = defaultFormat
        return dateFormater.string(from: Date())
    }

    /// Dateから日付文字列を作成
    ///
    /// - Parameter format: フォーマット
    /// - Returns: 日付文字列
    func toString(format: String = defaultFormat) -> String {
        let dateFormatter = DateFormatter()
        let cal = Calendar(identifier: .gregorian)
        dateFormatter.calendar = cal
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// 日付文字列からDateを作成
    ///
    /// - Parameters:
    ///   - dateString: 日付文字列
    ///   - format: フォーマット
    /// - Returns: Date
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

    
    /// 指定秒後のDateを作成
    ///
    /// - Parameter sec: 秒数
    /// - Returns: Date
    func afterDate(sec: TimeInterval) -> Date {
        return Date(timeInterval: sec, since: self)
    }
}
