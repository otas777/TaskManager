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
    
    /// タスク一覧
    private var taskList = [Task]()
    
    /// 現在の選択タブの管理
    private var currentType = ListType.all {
        didSet {
            
            self.allTaskButton.isSelected = false
            self.incompleteButton.isSelected = false
            self.completedButton.isSelected = false
            
            switch self.currentType {
            case .all:
                self.taskListUseCase.findAll(changed: self.onTaskChanged(_: ))
                self.allTaskButton.isSelected = true
                self.emptyLabel.text = "タスクがありません。\n右下のボタンから登録できます。"


            case .incomplete:
                self.taskListUseCase.findIncomplete(changed: self.onTaskChanged(_: ))
                self.incompleteButton.isSelected = true
                self.emptyLabel.text = "未完了タスクはありません"

            case .completed:
                self.taskListUseCase.findCompleted(changed: self.onTaskChanged(_:))
                self.completedButton.isSelected = true
                self.emptyLabel.text = "完了タスクはありません"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskListUseCase = TaskListUseCase(with: RealmTaskRepository(api: FirebaseAPI()),
                                               RealmAuthRepository(api: FirebaseAPI()))

        self.currentType = .all

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
        
        self.addTaskButton.layer.cornerRadius = self.addTaskButton.frame.width / 2

        // APIからタスクを取得
        self.taskListUseCase.fetchTask()
    }
    
    deinit {
        print("TaskListViewController deinit")
        self.taskListUseCase.release()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "タスク一覧"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTaskDetail" {
            // タスクを設定
            let vc = segue.destination as! TaskDetailViewController
            vc.task = self.taskList[(sender as! NSIndexPath).row]
        }
    }
    
    func onTaskChanged(_ list: [Task]) {

        self.taskList.removeAll()
        self.taskList = list
        
        self.emptyLabel.isHidden = !self.taskList.isEmpty
        
        self.tableView.reloadData()
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

            self.taskListUseCase.createTask(title: title)
        })
        dialog.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(dialog, animated: true, completion: nil)

        
    }

    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        self.taskListUseCase.logout()
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
    
    /// 完了スイッチの値変更イベント
    ///
    /// - Parameter sender: スイッチ
    @objc func onValueChanged(sender: UISwitch) {
        
        /// 操作したスイッチのindexPathを取得
        let point = sender.convert(sender.bounds.origin, to:self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else {
            return
        }
        
        // タスクの値を更新
        var task = self.taskList[indexPath.row]
        task.is_completed = sender.isOn
        
        Loading.show()
        self.taskListUseCase.saveTask(task: task) { (error) in
            Loading.dismiss()
            if let error = error {
                sender.isOn = !sender.isOn
                RootViewController.shared?.showAlert(title: "タスク一覧", message: error.domain)
            }
        }
    }
}
