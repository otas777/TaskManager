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
    @IBOutlet weak var createDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseView.layer.cornerRadius = 4
        self.baseView.layer.masksToBounds = false
        self.baseView.layer.shadowColor = UIColor.black.cgColor
        self.baseView.layer.shadowOpacity = 0.3
        self.baseView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.baseView.layer.shadowRadius = 3
    }

    /// タスクの値を元に表示に反映
    ///
    /// - Parameter task: 対象のタスク
    func setData(task: Task) {
        
        self.titleLabel.text = task.title
        
        self.createDateLabel.text = task.create_date
        
        self.completedSwitch.isOn = task.is_completed
        
        self.baseView.backgroundColor = task.is_completed
            ? UIColor(named: "completed_task")  // 完了済みなら青系の色
            : UIColor(named: "normal_task")     // 未完了なら赤系の色

    }
    
}
