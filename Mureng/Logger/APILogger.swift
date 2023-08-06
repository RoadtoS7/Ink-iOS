//
//  APILogger.swift
//  Mureng
//
//  Created by 김수현 on 2023/07/29.
//

import Foundation
import OSLog

final class APILogger {
    static let shared: APILogger = .init()
    
    private let logger: Logger = .init()
    
    func logError(_ error: Error) {
        logger.error("\(error)")
    }
    
    func logDebug(_ message: String) {
        logger.debug("\(message)")
    }
    
    func logNotice(_ object: Any) {
        
    }
}
