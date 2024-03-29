//
//  String+.swift
//  Mureng
//
//  Created by 김수현 on 3/29/24.
//

import Foundation

extension String {
    func makeDateWithoutTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self) 
    }
}
