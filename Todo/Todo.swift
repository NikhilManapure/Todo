//
//  Todo.swift
//  Todo
//
//  Created by Nikhil Manapure on 02/10/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit
import RealmSwift

enum Priority: String {
    case low
    case normal
    case high
    
    case count
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .low
        case 1:
            self = .normal
        case 2:
            self = .high
        default:
            return nil
        }
    }
    
    var rawValueTitleized: String {
        get {
            return rawValue.titleized
        }
    }
}


class Todo: Object {
    
    dynamic var title: String = ""
    dynamic var createdOn: String = Date().toString()
    private dynamic var priorityRaw: Int = Priority.normal.hashValue
    
    var priority: Priority {
        get {
            return Priority(index: priorityRaw) ?? Priority.normal
        }
        set {
            priorityRaw = newValue.hashValue
        }
    }
    
    override class func primaryKey() -> String? {
        return "createdOn"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["priority"]
    }
    
    static var all: [Todo] {
        get {
            do {
                let realm = try Realm()
                return Array(realm.objects(Todo.self).sorted(byKeyPath: "createdOn", ascending: false))
            } catch {
                print("Todo.all - Something went wrong !!!")
            }
            return []
        }
    }

    func update(title: String? = nil, priority: Priority? = nil) {
        do {
            let realm = try Realm()
            try realm.write() {
                
                if let title = title {
                    if self.title != title {
                        self.title = title
                    }
                }
                
                if let priority = priority {
                    if self.priority != priority {
                        self.priority = priority
                    }
                }
                
                realm.add(self, update: true)
            }
        } catch {
            print("Todo.update - Something went wrong !!!")
        }
    }
    
    func delete() {
        do {
            let realm = try Realm()
            try realm.write() {
                realm.delete(self)
            }
        } catch {
            print("Todo.delete - Something went wrong !!!")
        }
    }
}
