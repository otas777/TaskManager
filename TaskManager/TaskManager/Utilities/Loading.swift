//
//  Loading.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/19.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import SVProgressHUD

class Loading {
    
    /// ローディングの表示
    static func show() {
        SVProgressHUD.show()
    }
    
    /// ローディングの非表示
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
}
