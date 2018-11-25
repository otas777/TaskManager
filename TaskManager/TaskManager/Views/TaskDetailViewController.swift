//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/23.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var taskListUseCase: TaskListUseCase!
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.items?.first?.title = ""
        
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onTaskSave(sender:)))
        self.navigationItem.rightBarButtonItem = button
        
        self.taskListUseCase = TaskListUseCase(with: FirebaseTaskRepository(), FirebaseAuthRepository())

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "TaskDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskDetailTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func onTaskSave(sender: UIBarButtonItem) {
        self.taskListUseCase.saveTask(task: self.task) { (error) in
            
        }
    }
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailTableViewCell", for: indexPath) as! TaskDetailTableViewCell
        cell.setData(task: self.task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
