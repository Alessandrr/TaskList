//
//  ViewController.swift
//  TaskList
//
//  Created by Александр Мамлыго on /47/2566 BE.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
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
    
    @objc private func addNewTask() {
        showAlert()
    }
    
    private func save(_ taskName: String) {
        StorageManager.shared.createTask(taskName) { [weak self] newTask in
            self?.taskList.append(newTask)
            let cellIndex = IndexPath(row: (self?.taskList.count ?? 1) - 1, section: 0)
            self?.tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
    
    private func fetchData() {
        StorageManager.shared.fetchTasks { result in
            switch result {
            case .success(let tasks):
                taskList = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        let selectedTask = taskList[indexPath.row]
        showAlert(task: selectedTask) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = taskList.remove(at: indexPath.row)
            StorageManager.shared.deleteTask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - Alert View Controller
extension TaskListViewController {
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update task" : "New task"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.updateTask(task, withNewName: taskName)
                completion()
            } else {
                self?.save(taskName)
            }
        }
        
        present(alert, animated: true)
    }
}


