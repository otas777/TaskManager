//
//  TaskListTableViewCell.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/23.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.layer.masksToBounds = false
        self.baseView.layer.shadowColor = UIColor.black.cgColor
        self.baseView.layer.shadowOpacity = 0.3
        self.baseView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.baseView.layer.shadowRadius = 5
    }

    func setData(task: Task) {
        
        self.titleLabel.text = task.title
        
        if task.reminder.isEmpty {
            self.reminderLabel.isHidden = true
        } else {
            self.reminderLabel.isHidden = false
            self.reminderLabel.text = task.reminder
        }
        
        self.createDateLabel.text = task.task_create_date
        
        self.completedSwitch.isOn = task.is_completed
        
    }
    
}
