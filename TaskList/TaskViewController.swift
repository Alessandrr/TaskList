//
//  TaskViewController.swift
//  TaskList
//
//  Created by Александр Мамлыго on /57/2566 BE.
//

import UIKit

class TaskViewController: UIViewController {
    
    weak var delegate: TaskViewControllerDelegate!
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        createButton(
            withTitle: "Save Task",
            andColor: UIColor(named: "MilkBlue") ?? .systemBlue,
            action: UIAction {[unowned self] _ in
                save()
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButton(
            withTitle: "Cancel",
            andColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextField, saveButton, cancelButton)
        setupConstraints()
    }
    
    private func save() {
        let task = Task(context: viewContext)
        task.title = taskTextField.text
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        
        delegate.reloadData()
        dismiss(animated: true)
    }
}

//MARK: - View settings
private extension TaskViewController {
    func setupSubviews(_ views: UIView...) {
        views.forEach { subView in
            view.addSubview(subView)
        }
    }
}

//MARK: - UI elements setup
private extension TaskViewController {
    func createButton(withTitle title: String, andColor color: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }
}


//MARK: - Layout settings
private extension TaskViewController {
    func setupConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        //taskTextField
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 80
            ),
            taskTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 40
            ),
            taskTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -40
            )
        ])
        
        //saveButton
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(
                equalTo: taskTextField.bottomAnchor,
                constant: 20
            ),
            saveButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 40
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -40
            )
        ])
        
        //cancelButton
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: saveButton.bottomAnchor,
                constant: 20
            ),
            cancelButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 40
            ),
            cancelButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -40
            )
        ])
    }
}
