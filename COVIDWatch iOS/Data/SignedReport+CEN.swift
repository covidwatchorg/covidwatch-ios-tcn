//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import ContactTracingCEN

extension SignedReport {
    
    func configure(with cenSignedReport: ContactTracingCEN.SignedReport) {
        memoType = Int16(cenSignedReport.report.memoType.rawValue)
        memoData = cenSignedReport.report.memoData
        startPeriod = Int16(cenSignedReport.report.startPeriod)
        endPeriod = Int16(cenSignedReport.report.endPeriod)
        contactEventKeyBytes = cenSignedReport.report.contactEventKeyBytes
        reportVerificationPublicKeyBytes = cenSignedReport.report.reportVerificationPublicKeyBytes
        signatureBytes = cenSignedReport.signatureBytes
    }
    
}
