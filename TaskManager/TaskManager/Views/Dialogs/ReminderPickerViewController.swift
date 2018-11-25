//
//  ReminderPickerViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/25.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

protocol ReminderPickerDelegate {
    func onReminderPicker(date: String?)
}

class ReminderPickerViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: ReminderPickerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    private func initialize() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.baseView.layer.cornerRadius = 8
        self.baseView.clipsToBounds = true
        
        // 1時間後に設定
        self.datePicker.date = Date(timeInterval: 60 * 60, since: Date())
    }

    @IBAction func onOk(_ sender: UIButton) {
        self.delegate?.onReminderPicker(date: self.datePicker.date.toString())
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func onCancel(_ sender: UIButton) {
        self.delegate?.onReminderPicker(date: nil)
        self.dismiss(animated: false, completion: nil)
    }
}


extension ReminderPickerViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogViewController(presentedViewController: presented, presenting: presenting)
    }
    
}
