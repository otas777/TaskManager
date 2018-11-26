//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/18.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit
import RealmSwift

enum ListType {
    case all
    case incomplete
    case completed
}

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var allTaskButton: UIButton!
    @IBOutlet weak var incompleteButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var taskListUseCase: TaskListUseCase!
    
    private var taskList: Results<Task>!
    private var notificationToken: NotificationToken?
    
    private var currentType = ListType.all {
        didSet {
            
            self.notificationToken?.invalidate()
            self.notificationToken = nil
            
            self.allTaskButton.isSelected = false
            self.incompleteButton.isSelected = false
            self.completedButton.isSelected = false
            
            var emptytext = ""
            switch self.currentType {
            case .all:
                self.taskList = RealmUtil.findAll().sorted(byKeyPath: "task_create_date", ascending: false)
                emptytext = "タスクがありません。\n右下のボタンから登録できます。"
                self.allTaskButton.isSelected = true


            case .incomplete:
                self.taskList = RealmUtil.find(format: "is_completed==NO").sorted(byKeyPath: "task_create_date", ascending: false)
                self.incompleteButton.isSelected = true
                emptytext = "未完了タスクはありません"

            case .completed:
                self.taskList = RealmUtil.find(format: "is_completed==YES").sorted(byKeyPath: "task_create_date", ascending: false)
                self.completedButton.isSelected = true
                emptytext = "完了タスクはありません"
            }
            
            self.notificationToken = self.taskList.observe { (change) in
                print("タスク更新")
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.taskList.isEmpty
            }
            
            self.emptyLabel.isHidden = !self.taskList.isEmpty
            self.emptyLabel.text = emptytext

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskListUseCase = TaskListUseCase(with: FirebaseTaskRepository(), FirebaseAuthRepository())
        
        self.currentType = .all

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
        self.notificationToken = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "タスク一覧"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTaskDetail" {
            let vc = segue.destination as! TaskDetailViewController
            // スタンドアローン化してから渡す
            vc.task = Task(value: self.taskList[(sender as! NSIndexPath).row])
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
            
            guard let title = dialog.textFields?.first?.text, !title.isEmpty else {
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
    
    @IBAction func onTab(_ sender: UIButton) {
        if sender == self.allTaskButton {
            self.currentType = .all
        } else if sender == self.incompleteButton {
            self.currentType = .incomplete
        } else if sender == self.completedButton {
            self.currentType = .completed
        }
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
        cell.completedSwitch.addTarget(self, action: #selector(self.onValueChanged(sender:)), for: .valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "toTaskDetail", sender: indexPath)
    }
    
    @objc func onValueChanged(sender: UISwitch) {
        
        let point = sender.convert(sender.bounds.origin, to:self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else {
            return
        }
        
        // スタンドアローン化
        let standaloneTask = Task(value: self.taskList[indexPath.row])
        standaloneTask.is_completed = sender.isOn
        self.taskListUseCase.saveTask(task: standaloneTask) { (error) in
            if let error = error {
                sender.isOn = !sender.isOn
                self.showAlert(message: error.domain)
            }
        }
    }
}
