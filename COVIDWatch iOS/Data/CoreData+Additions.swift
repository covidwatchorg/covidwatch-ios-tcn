//
//  Created by Zsombor Szabo on 13/03/2020.
//
//

import Foundation

enum UploadState: Int16 {
    case notUploaded = 0
    case uploading
    case uploaded
}

extension ProcessInfo {
  var isRunningXCTest: Bool {
    return self.arguments.contains("XCTest")
  }
}

extension String {
    var bool: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        default:
            return false
        }
    }
}
