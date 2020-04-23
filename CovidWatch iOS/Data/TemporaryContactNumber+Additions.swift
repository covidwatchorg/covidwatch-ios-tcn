//
//  Created by Zsombor Szabo on 18/04/2020.
//

import Foundation

extension TemporaryContactNumber {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.foundDate = Date()
    }
    
}
