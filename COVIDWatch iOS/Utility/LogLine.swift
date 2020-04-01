//
//  LogLine.swift
//  COVIDWatch iOS
//
//  Created by Manu Eder on 31.03.20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import os.log

class LogLine : NSObject, NSCoding {
    var line: String = ""
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("logfile")
    
    init(line: String) {
        self.line = line
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(line, forKey: PropertyKey.line)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let aline = aDecoder.decodeObject(forKey: PropertyKey.line) as? String else {
            os_log("Unable to decode line.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(line: aline)
    }
    
    static func formatD(_ date: Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "dd HH:mm:ss"
        return dF.string(from: Date())
    }
}

struct PropertyKey {
    static let line = "line"
}
