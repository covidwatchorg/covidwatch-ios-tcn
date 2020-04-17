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

extension Thread {
  var isRunningXCTest: Bool {
    for key in self.threadDictionary.allKeys {
      guard let keyAsString = key as? String else {
        continue
      }
    
      if keyAsString.split(separator: ".").contains("xctest") {
        return true
      }
    }
    return false
  }
}
