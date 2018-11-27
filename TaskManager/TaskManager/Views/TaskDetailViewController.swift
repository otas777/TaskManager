//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/23.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var memoTextView: UITextView!
    
    private var taskListUseCase: TaskListUseCase!
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.items?.first?.title = ""
        
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.onTaskSave(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.taskListUseCase = TaskListUseCase(with: RealmTaskRepository(api: FirebaseAPI()),
                                               RealmAuthRepository(api: FirebaseAPI()))

        self.titleField.text = self.task.title
        self.titleField.addTarget(self, action: #selector(self.onEditingChanged(sender:)), for: .editingChanged)

        self.memoTextView.text = self.task.memo
        self.memoTextView.delegate = self
        self.memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.memoTextView.layer.borderWidth = 1
        
        self.completedSwitch.isOn = self.task.is_completed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "タスク詳細"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "タスク詳細", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onTaskSave(sender: UIBarButtonItem) {
        self.taskListUseCase.saveTask(task: self.task) { (error) in
            if let error = error {
                self.showAlert(message: error.domain)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func onEditingChanged(sender: UITextField) {
        self.task.title = self.titleField.text ?? ""
    }
    
    @IBAction func onValueChanged(_ sender: UISwitch) {
        self.task.is_completed = sender.isOn
    }
}

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.task.memo = textView.text
    }
    
}
