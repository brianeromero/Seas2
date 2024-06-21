//
//  Logger.swift
//  Seas2
//
//  Created by Brian Romero on 6/21/24.
//

import Foundation

struct Logger {
    static func log(_ message: String, view: String) {
        print("[\(view)] \(message)")
    }
}
