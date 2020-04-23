//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import TCNClient

extension SignedReport {
    
    func configure(with tcnSignedReport: TCNClient.SignedReport) {
        memoType = Int16(tcnSignedReport.report.memoType.rawValue)
        memoData = tcnSignedReport.report.memoData
        startIndex = Int16(tcnSignedReport.report.startIndex)
        endIndex = Int16(tcnSignedReport.report.endIndex)
        temporaryContactKeyBytes = tcnSignedReport.report.temporaryContactKeyBytes
        reportVerificationPublicKeyBytes = tcnSignedReport.report.reportVerificationPublicKeyBytes
        signatureBytes = tcnSignedReport.signatureBytes
    }
    
}
