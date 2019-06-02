//
//  FileManager.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/24.
//

import Foundation

enum PathType: String {
    case signal = "Signal"
    case exception = "NSException"
}
class Utils {
    fileprivate static func fileName() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
        let dateString = dateFormatter.string(from: Date())
        return "\(dateString).log"
    }
}


// MARK: - file
extension Utils {
   static func save(type: PathType, message: String) {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/\(type.rawValue)")
        if let crashPath = path {
            if !FileManager.default.fileExists(atPath: crashPath) {
                try? FileManager.default.createDirectory(atPath: crashPath, withIntermediateDirectories: true, attributes: nil)
            }
            let filePath = crashPath.appending("\(Utils.fileName())")
            try? message.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    // 删除所有的
    static func removeAll(type: PathType) {
        for path  in Utils.crashList(type: type) {
            try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    static func crashList(type: PathType) -> [String] {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/\(type.rawValue)")
        if let crashPath = path {
            var logFilePaths:[String] = []
            let fileList = try? FileManager.default.contentsOfDirectory(atPath: crashPath)
            if let list = fileList {
                for fileName in list {
                    if let  _ = fileName.range(of: ".log") {
                        logFilePaths.append(crashPath + "/" + fileName)
                    }
                }
            }
        }
        return []
    }
    
    static func read(for type: PathType) -> [String] {
        var crashStrings = [String]()
        for path  in Utils.crashList(type: type) {
            if let content = try? String.init(contentsOfFile: path, encoding: .utf8)   {
                crashStrings.append(content)
            }
        }
        return crashStrings
    }
    
}

extension Utils {
    static func dateString() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss SS"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
}




