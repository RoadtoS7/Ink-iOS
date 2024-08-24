//
//  Dictionary+.swift
//  Mureng
//
//  Created by 김수현 on 8/25/24.
//


extension Dictionary: CustomStringConvertible {
    var description: String {
        self.reduce("") { (partialResult: String, arg1) in
            let (key, value) = arg1
            return partialResult + "/n" + "\(key) : \(value)"
        }
    }
}
