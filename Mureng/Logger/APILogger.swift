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
    
    static let logger: Logger = .init(subsystem: Bundle.main.bundleIdentifier ?? "",
                                      category: "APILogger")
    
    static func logError(_ error: Error) {
        logger.error("\(error)")
    }
    
    static func logDebug(_ message: String) {
        logger.debug("\(message)")
    }
    
    static func logNotice(_ object: Any) {
        
    }
}
