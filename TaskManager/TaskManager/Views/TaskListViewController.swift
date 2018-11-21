//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/18.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var taskListUseCase: TaskListUseCase!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskListUseCase = TaskListUseCase(taskListDelegate: self, with: FirebaseTaskRepository(), FirebaseAuthRepository())
        
        self.taskListUseCase.getTaskList()
    }
    
    deinit {
        print("TaskListViewController deinit")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "タスク一覧", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - IBAction

extension TaskListViewController {

    @IBAction func onCreateTask(_ sender: UIBarButtonItem) {
        
        API.createTask { (result) in
            print(result)
        }
        
    }
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        RealmUtil.deleteAll(type: Auth.self)
        RootViewController.shared?.toLogin()
    }
}

// MARK: - TaskListDelegate

extension TaskListViewController: TaskListDelegate {
    func onGetTaskCompleted(error: NSError?) {
        if let error = error {
            self.showAlert(message: error.domain)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
