//
//  RootViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/19.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    static var shared: RootViewController? {
        let app = UIApplication.shared.delegate as? AppDelegate
        return app?.window?.rootViewController as? RootViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = Auth.current {
            // ログイン済みの場合はログイン画面をスキップ
            self.toTaskList()
        } else {
            self.toLogin()
        }
    }
    
    func toLogin() {
        self.transition(to: LoginViewController.instantiate(storyboard: self.storyboard))
    }
    
    func toTaskList() {
        self.transition(to: TaskListViewController.instantiate(storyboard: self.storyboard))
    }
    
    func transition(to vc: UIViewController?) {
        
        guard let vc = vc else {
            return
        }
        
        // RootViewControllerの子ビューを削除
        self.children.forEach { (childVC) in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }

        // 以下はRootViewController.viewDidLoadメソッドの内容をそのまま移植
        self.addChild(vc)
        vc.view.frame = self.view.bounds
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}
