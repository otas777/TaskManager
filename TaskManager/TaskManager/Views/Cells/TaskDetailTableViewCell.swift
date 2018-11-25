//
//  TaskDetailTableViewCell.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/24.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class TaskDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var memoTextView: UITextView!
    
    private var task: Task!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleField.addTarget(self, action: #selector(self.onEditingChanged(sender:)), for: .editingChanged)

        self.reminderSwitch.addTarget(self, action: #selector(self.onSwitchChanged(sender:)), for: .valueChanged)

        self.memoTextView.delegate = self
        
        self.memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.memoTextView.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(task: Task) {
        self.task = task
        
        self.titleField.text = task.title
        self.reminderLabel.text = task.reminder
        self.reminderSwitch.isOn = !task.reminder.isEmpty
        self.memoTextView.text = task.memo
    }
    
    @objc func onEditingChanged(sender: Any) {
        self.task.title = self.titleField.text ?? ""
    }
    
    @objc func onSwitchChanged(sender: UISwitch) {
        if self.reminderSwitch.isOn {
            let vc = ReminderPickerViewController()
            vc.delegate = self
            RootViewController.shared?.present(vc, animated: false, completion: nil)
        
        } else {
            self.task.reminder = ""
        }
    }
}


extension TaskDetailTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.task.memo = textView.text
    }
}

extension TaskDetailTableViewCell: ReminderPickerDelegate {
    
    func onReminderPicker(date: String?) {
        if let date = date {
            self.reminderLabel.text = date
            self.task.reminder = date
        
        } else {
            self.reminderLabel.text = task.reminder
            self.reminderSwitch.isOn = !task.reminder.isEmpty
        }
    }
}
