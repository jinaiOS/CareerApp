//
//  Log.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/11.
//

import Foundation

struct Log {
    typealias WriteHandler = (Log.Level, String, String, Int, Any?, DispatchQueue?) -> Void
    fileprivate static let timeFormat : DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY/MM/dd-HH:mm:ss.SSS"
        return dateformatter
    }()
    
    fileprivate static let consoleQueue = DispatchQueue(label: "console-log-queue")
    
    fileprivate static let isEnabledConsole = true
    
    fileprivate static let makeFormat: (Log.Level, String, String, Int, Any?) -> String = {
        level, file, function, line, message in
        guard let fileFirstIndex = file.reversed().firstIndex(of: ".")?.base else {
            return ""
        }
        let className = file[..<file.index(fileFirstIndex, offsetBy: -1)]
        var log = String()
        if let message = message {
            log = "\(className).\(function):\(line) - \(message)"
        } else {
            log = "\(className).\(function):\(line)"
        }
        return "\(Log.timeFormat.string(from: Date())) \(level.consoleSymbol) \(log)"
    }
    
    fileprivate static let writeConsole: WriteHandler = { level, file, function, line, message, queue in
        let msg = makeFormat(level, file, function, line, message)
        let execute: () -> Void = {
            print(msg)
        }
        if let queue = queue {
            queue.async(execute: execute)
        } else {
            execute()
        }
    }
    
    fileprivate enum Destination {
        case console
        
        func write(_ level: Log.Level, _ file: String, _ function: String, _ line: Int, _ message: Any? = nil) {
#if DEBUG
            Log.writeConsole(level, (file as NSString).lastPathComponent, function, line, message, Log.consoleQueue)
            
#else
            return
#endif
        }
        
    }
    
    enum Level {
        case verbose
        case debug
        case info
        case warning
        case error
        
        var consoleSymbol: String {
            switch self {
            case .verbose:  return "💬"
            case .debug:    return "ℹ️"
            case .info:     return "✅"
            case .warning:  return "⚠️"
            case .error:    return "❌"
            }
        }
        
        var fileSymbol: String {
            switch self {
            case .verbose:  return "V"
            case .debug:    return "D"
            case .info:     return "I"
            case .warning:  return "W"
            case .error:    return "E"
            }
        }
    }
}

extension Log {
    /// 주어진 메세지를 verbose 타입으로 출력
    ///
    /// - Parameter
    ///   - message:  출력할 메세지
    ///   - file:     파일명
    ///   - function: 함수명
    ///   - line:     라인
    static func v(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Log.Destination.console.write(.verbose, file, function, line, message())
    }
    
    /// 주어진 메세지를 debug 타입으로 출력
    ///
    /// - Parameter
    ///   - message:  출력할 메세지
    ///   - file:     파일명
    ///   - function: 함수명
    ///   - line:     라인
    static func d(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Log.Destination.console.write(.debug, file, function, line, message())
    }
    
    /// 주어진 메세지를 info 타입으로 출력
    ///
    /// - Parameter
    ///   - message:  출력할 메세지
    ///   - file:     파일명
    ///   - function: 함수명
    ///   - line:     라인
    static func i(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Log.Destination.console.write(.info, file, function, line, message())
    }
    
    /// 주어진 메세지를 warning 타입으로 출력
    ///
    /// - Parameter
    ///   - message:  출력할 메세지
    ///   - file:     파일명
    ///   - function: 함수명
    ///   - line:     라인
    static func w(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Log.Destination.console.write(.warning, file, function, line, message())
    }
    
    /// 주어진 메세지를 error 타입으로 출력
    ///
    /// - Parameter
    ///   - message:  출력할 메세지
    ///   - file:     파일명
    ///   - function: 함수명
    ///   - line:     라인
    static func e(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Log.Destination.console.write(.error, file, function, line, message())
    }
}
