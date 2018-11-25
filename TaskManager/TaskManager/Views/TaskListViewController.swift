//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/18.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var taskListUseCase: TaskListUseCase!
    
    private var taskList: Results<Task>!
    private var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskListUseCase = TaskListUseCase(with: FirebaseTaskRepository(), FirebaseAuthRepository())
        
        self.title = "タスク一覧"

        self.taskList = RealmUtil.findAll()?.sorted(byKeyPath: "task_create_date", ascending: false)
        self.notificationToken = self.taskList?.observe { (change) in
            print("タスク更新")
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !self.taskList.isEmpty
        }
        self.emptyLabel.isHidden = !self.taskList.isEmpty

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
        
        self.addTaskButton.layer.cornerRadius = self.addTaskButton.frame.width / 2

        self.taskListUseCase.fetchTask() { (error) in
            if let error = error {
                self.showAlert(message: error.domain)
                
            } else {
                self.emptyLabel.isHidden = !self.taskList.isEmpty
            }
        }
    }
    
    deinit {
        print("TaskListViewController deinit")
        self.notificationToken?.invalidate()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTaskDetail" {
            let vc = segue.destination as! TaskDetailViewController
            // スタンドアローン化してから渡す
            vc.task = Task.init(value: self.taskList[(sender as! NSIndexPath).row])
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "タスク一覧", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - IBAction

extension TaskListViewController {

    @IBAction func onCreateTask(_ sender: UIButton) {

        let dialog = UIAlertController(title: "新規タスク", message: nil, preferredStyle: .alert)
        dialog.addTextField(configurationHandler: nil)
        dialog.textFields?.first?.placeholder = "タスク名"
        dialog.addAction(UIAlertAction(title: "作成", style: .default) { (action) in
            
            guard let title = dialog.textFields?.first?.text, title.isEmpty else {
                return
            }

            self.taskListUseCase.createTask(title: title) { (error) in
                if let error = error {
                    self.showAlert(message: error.domain)
                }
            }
        })
        dialog.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(dialog, animated: true, completion: nil)

        
    }
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        RealmUtil.deleteAll(type: Auth.self)
        RealmUtil.deleteAll(type: Task.self)
        RootViewController.shared?.toLogin()
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        cell.setData(task: self.taskList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "toTaskDetail", sender: indexPath)
    }
}
