//
//  AppLogger.swift
//  ImageViewer
//
//  Created by hyperlink on 08/05/26.
//

import Foundation

struct AppLogger {
    static func log(_ message: Any,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("🪵 [\(fileName):\(line)] \(function) → \(message)")
        #endif
    }
}
