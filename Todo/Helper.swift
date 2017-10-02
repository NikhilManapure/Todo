//
//  Helper.swift
//  Todo
//
//  Created by Nikhil Manapure on 02/10/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit

extension Date {
    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension String {
    var titleized: String {
        get {
            var newString: String = ""
            for character in characters {
                if "A"..."Z" ~= character {
                    newString.append(" ")
                }
                newString.append(character)
            }
            let first = String(characters.prefix(1)).capitalized
            return first + String(newString.characters.dropFirst())
        }
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.values = [-18.0, 18.0, -14.0, 14.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}


class SortButton: UIButton {
    var isAscending: Bool = false {
        didSet {
            switch isAscending {
            case false:
                setTitle(" 🔽 ", for: .normal)
            case true:
                setTitle(" 🔼 ", for: .normal)
            }
        }
    }
}
