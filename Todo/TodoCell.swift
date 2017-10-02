//
//  TodoCell.swift
//  Todo
//
//  Created by Nikhil Manapure on 02/10/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!

    func configure(with todo: Todo) {
        titleLabel.text = todo.title
        createdOnLabel.text = "\(todo.createdOn)"
        priorityLabel.text = todo.priority.rawValueTitleized
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        createdOnLabel.text = ""
        priorityLabel.text = ""
    }
}

extension TodoCell {
    @nonobjc static var identifier = String(describing: TodoCell.self)
    @nonobjc static var nibName = String(describing: TodoCell.self)
}
