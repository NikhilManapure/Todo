//
//  ViewController.swift
//  Todo
//
//  Created by Nikhil Manapure on 02/10/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var sortButton: SortButton!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!

    var allTodo: [Todo] = []
    var filteredTodo: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTodoTableView()
        setupPrioritySegmentedControl()
        sortButton.isAscending = false
        
        allTodo = Todo.all
        filteredTodo = filteredTodos(for: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Edit":
                if let destination = segue.destination as? AddTodoViewController {
                    destination.delegate = self
                    if let todo = sender as? Todo {
                        destination.todo = todo
                    }
                }
            default:
                break
            }
        }
    }
    
    
    //MARK: - View Setup
    
    func setupTodoTableView() {
        let nib = UINib(nibName: TodoCell.nibName, bundle:nil)
        todoTableView.register(nib, forCellReuseIdentifier: TodoCell.identifier)
        todoTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    func setupPrioritySegmentedControl() {
        prioritySegmentedControl.removeAllSegments()
        for index in 0..<Priority.count.hashValue + 1 {
            if index == 0 {
                prioritySegmentedControl.insertSegment(withTitle: "All", at: index, animated: false)
            } else {
                prioritySegmentedControl.insertSegment(withTitle: Priority(index: index - 1)?.rawValueTitleized, at: index, animated: false)
            }
        }
        prioritySegmentedControl.selectedSegmentIndex = 0
    }
    
    
    //MARK: - IBActions

    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Edit", sender: nil)
    }
    
    @IBAction func prioritySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        reloadData()
    }
   
    @IBAction func sortButtonTouched(_ sender: SortButton) {
        sender.isAscending = !sender.isAscending
        let comparisonResult: ComparisonResult = sender.isAscending ? .orderedAscending : .orderedDescending
        filteredTodo = filteredTodo.sorted { $0.createdOn.localizedCaseInsensitiveCompare($1.createdOn) == comparisonResult }
        todoTableView.reloadData()
    }
    
    
    //MARK: - Convenience methods

    func reloadData(fromDB: Bool = false) {
        if fromDB {
            allTodo = Todo.all
        }
        filteredTodo = filteredTodos(for: searchBar.text)
        todoTableView.reloadData()
    }
    
    func filteredTodos(for searchText: String?) -> [Todo] {
        // Get all
        var filteredTodo = allTodo
        
        // Get the todos with selected priority
        if prioritySegmentedControl.selectedSegmentIndex != 0 {
            filteredTodo = filteredTodo.filter {
                $0.priority.hashValue == prioritySegmentedControl.selectedSegmentIndex - 1
            }
        }
        
        // Get the todos filtered with search text(if any)
        if let searchText = searchText?.trimmingCharacters(in: CharacterSet.whitespaces) {
            if !searchText.isEmpty {
                // "c" is for case insensitive
                // "d" is for diacritic insensitive
                let predicate = NSPredicate(format: "SELF contains[cd] %@", searchText)
                filteredTodo = filteredTodo.filter { predicate.evaluate(with: $0.title) }
            }
        }
        
        // Sort it
        if sortButton.isAscending {
            filteredTodo = filteredTodo.sorted { $0.createdOn.localizedCaseInsensitiveCompare($1.createdOn) == .orderedAscending }
        }
        
        return filteredTodo
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath as IndexPath) as? TodoCell {
            cell.configure(with: filteredTodo[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let todoToBeDeleted = self.filteredTodo[index.row]
            if let deletionIndex = self.allTodo.index(of: todoToBeDeleted) {
                self.allTodo.remove(at: deletionIndex)
                self.filteredTodo.remove(at: index.row)
                todoToBeDeleted.delete()
                self.todoTableView.deleteRows(at: [index], with: .left)
            }
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: " Edit ") { action, index in
            self.performSegue(withIdentifier: "Edit", sender: self.filteredTodo[index.row])
        }
        edit.backgroundColor = .orange
        return [delete, edit]
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text ?? "").isEmpty {
            searchBar.text = nil
            reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData()
    }
}


extension ViewController: AddTodoViewControllerDelegate {
    func addTodoViewControllerDidSave(todo: Todo) {
        if todo.priority.hashValue != prioritySegmentedControl.selectedSegmentIndex - 1 {
            if prioritySegmentedControl.selectedSegmentIndex != 0 {
                // To remind user that newly saved todo is in different section.
                prioritySegmentedControl.shake()
            }
        }
        reloadData(fromDB: true)
    }
}
