//
//  FileManager.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/24.
//

import Foundation
import Zip
import AdSupport

enum PathType: String {
    case signal = "Signal"
    case exception = "NSException"
    case all = "all"
    static var types:[PathType] = [.exception, .signal]
}

class Utils {
    private var cachePath:String
    private var exceptionPath: String
    private var signalPath:String

    init?() {
        guard let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        self.cachePath = cache
        self.exceptionPath = cachePath + "/\(PathType.exception.rawValue)"
        self.signalPath = cachePath + "/\(PathType.signal.rawValue)"
    }
}


// MARK: - static method
extension Utils {
    static func fileName() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
        let dateString = dateFormatter.string(from: Date())
        return "\(dateString).log"
    }
    static func dateString() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss SS"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }

    static func zipName() -> String {
        return "crash_log.zip"
    }

    static func identifity() -> String {
        let systemVersion = UIDevice.current.systemVersion
        let sysName = UIDevice.current.systemName
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString

        return "== uuid:\(uuid) ==== systemVersion:\(systemVersion) == systemName:\(sysName)== idfa:\(idfa)"
    }
}

extension Utils {
    @discardableResult
    func existFolder() -> Bool {
        var exception = false
        var signal = false
        var objc = ObjCBool.init(booleanLiteral: true)
        if !FileManager.default.fileExists(atPath: exceptionPath, isDirectory: &objc) {
            try? FileManager.default.createDirectory(atPath: exceptionPath, withIntermediateDirectories: true, attributes: nil)
            exception = true
        }else {
            exception = true
        }
        if !FileManager.default.fileExists(atPath: signalPath, isDirectory: &objc) {
            try? FileManager.default.createDirectory(atPath: signalPath, withIntermediateDirectories: true, attributes: nil)
            signal = true
        }else {
            signal = true
        }

        if exception && signal {
            return true
        }
        return false
    }
}


// MARK: - file
extension Utils {
    func save (type: PathType, message: String)  {
        if !existFolder() {
            return
        }
        switch type {
        case .exception:
             try? message.write(toFile: exceptionPath + "/\(Utils.fileName())", atomically: true, encoding: String.Encoding.utf8)
            break
        case .signal:
             try? message.write(toFile: signalPath + "/\(Utils.fileName())", atomically: true, encoding: String.Encoding.utf8)
            break
        default:
            break
        }
    }

    func remove(type: PathType)  {
        switch type {
        case .all:
            if FileManager.default.fileExists(atPath: cachePath + "/\(Utils.zipName())") {
                try? FileManager.default.removeItem(atPath: cachePath + "/\(Utils.zipName())")
            }
            try? FileManager.default.removeItem(atPath: signalPath)
            fallthrough
        case .exception:
             try? FileManager.default.removeItem(atPath: exceptionPath)
            break
        case .signal:
            try? FileManager.default.removeItem(atPath: signalPath)
            break
        }
    }
}


extension Utils {
    func zip(password: String?) -> String? {
        if !existFolder() {
            return nil
        }
        let zipPath = cachePath + "/\(Utils.zipName())"
        let fileURL = [exceptionPath, signalPath].map { (f) -> URL in
            return URL.init(fileURLWithPath: f)
        }

        do {
            try Zip.zipFiles(paths: fileURL, zipFilePath: URL.init(fileURLWithPath: zipPath), password: password, progress: nil)
            return zipPath
        } catch let error {
            print("\(error)")
            return nil
        }
    }
}


