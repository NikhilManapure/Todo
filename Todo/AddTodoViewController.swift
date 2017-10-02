//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Nikhil Manapure on 02/10/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit

protocol AddTodoViewControllerDelegate: class {
    func addTodoViewControllerDidSave(todo: Todo)
}

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    var todo: Todo = Todo()
    weak var delegate: AddTodoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPrioritySegmentedControl()
        
        if !todo.title.isEmpty {
            titleTextField.text = todo.title
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    func setupPrioritySegmentedControl() {
        prioritySegmentedControl.removeAllSegments()
        for index in 0..<Priority.count.hashValue {
            prioritySegmentedControl.insertSegment(withTitle: Priority(index: index)?.rawValueTitleized, at: index, animated: false)
        }
        prioritySegmentedControl.selectedSegmentIndex = todo.priority.hashValue
    }
    
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        if let titleText = titleTextField.text {
            if !titleText.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                let priority = Priority(index: prioritySegmentedControl.selectedSegmentIndex) ?? .normal
                todo.update(title: titleText, priority: priority)
                delegate?.addTodoViewControllerDidSave(todo: todo)
                navigationController?.popViewController(animated: true)
            } else {
                titleTextField.text = nil
                titleTextField.shake()
                titleTextField.becomeFirstResponder()
            }
        } else {
            titleTextField.shake()
            titleTextField.becomeFirstResponder()
        }
    }
}


extension AddTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
