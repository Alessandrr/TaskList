//
//  ViewController.swift
//  TaskList
//
//  Created by Александр Мамлыго on /47/2566 BE.
//

import UIKit

enum AlertStyle {
    case create
    case update(task: Task)
}

class TaskListViewController: UITableViewController {
    
    private let viewContext = StorageManager.shared.persistentContainer.viewContext
    
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        taskList = StorageManager.shared.fetchTasks()
    }

    private func setupNavigationBar() {
        title = "Task list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    private func addNewTask() {
        showAlert(
            withTitle: "New Task",
            andMessage: "What do you want to do?",
            style: .create
        )
    }
    
    private func showAlert(withTitle title: String, andMessage message: String, style: AlertStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let proceedAction: UIAlertAction
        
        switch style {
        case .create:
            proceedAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                save(task)
            }
            
            alert.addTextField { textField in
                textField.placeholder = "New task"
            }
        case let .update (task):
            proceedAction = UIAlertAction(title: "Update", style: .default) { [unowned self] _ in
                guard let newTaskName = alert.textFields?.first?.text, !newTaskName.isEmpty else { return }
                update(task, newName: newTaskName)
            }
            
            alert.addTextField() { textField in
                textField.text = task.title
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(proceedAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        StorageManager.shared.createTask(taskName) { [weak self] newTask in
            self?.taskList.append(newTask)
            let cellIndex = IndexPath(row: (self?.taskList.count ?? 1) - 1, section: 0)
            self?.tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
    
    private func update(_ task: Task, newName: String) {
        StorageManager.shared.updateTask(task, withNewName: newName)
        taskList = StorageManager.shared.fetchTasks()
        tableView.reloadData()
    }
}

//MARK: - UITableView Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(
            withTitle: "Update task",
            andMessage: "Enter a new name for the task:",
            style: .update(task: taskList[indexPath.row])
        )
    }
}


