//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import CoreData
import os.log
import Firebase

open class SignedReportsUploader: NSObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<SignedReport>
    
    private var db: Firestore = AppDelegate.getFirestore()
    
    override init() {
        let managedObjectContext = PersistentContainer.shared.viewContext
        let request: NSFetchRequest<SignedReport> = SignedReport.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SignedReport.uploadState, ascending: false)]
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "uploadState == %d", UploadState.notUploaded.rawValue)
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()

        self.fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
            self.uploadSignedReportsIfNeeded()
        } catch {
            os_log("Fetched results controller perform fetch failed: %@", log: .app, type: .error, error as CVarArg)
        }
    }
    
    private func uploadSignedReportsIfNeeded() {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }
        let toUpload = fetchedObjects.filter({ $0.uploadState == UploadState.notUploaded.rawValue })
        self.uploadSignedReports(toUpload)
    }

    // swiftlint:disable:next function_body_length
    private func uploadSignedReports(_ signedReports: [SignedReport]) {
        guard !signedReports.isEmpty else { return }

        signedReports.forEach { (signedReport) in

            let signatureBytesBase64EncodedString = signedReport.signatureBytes?.base64EncodedString() ?? ""
            
            os_log(
                "Uploading signed report (%@)...",
                log: .app,
                signatureBytesBase64EncodedString
            )
            signedReport.uploadState = UploadState.uploading.rawValue

            // get url to submit to
            let apiUrlString = getAPIUrl(getAppScheme())
            if let submitReportUrl = URL(string: "\(apiUrlString)/submitReport") {
                // build correct payload
                let reportUpload = ReportUpload(
                    temporaryContactKeyBytes: signedReport.temporaryContactKeyBytes,
                    startIndex: signedReport.startIndex,
                    endIndex: signedReport.endIndex,
                    memoData: signedReport.memoData,
                    memoType: signedReport.memoType,
                    signatureBytes: signedReport.signatureBytes,
                    reportVerificationPublicKeyBytes: signedReport.reportVerificationPublicKeyBytes
                )

                // set encoding to base64 and snake_case
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                encoder.dataEncodingStrategy = .base64

                guard let uploadData = try? encoder.encode(reportUpload) else {
                    os_log(
                        "Failed to encode signed report (%@) failed: %@",
                        log: .app,
                        type: .error,
                        "\(reportUpload)"
                    )
                    signedReport.uploadState = UploadState.notUploaded.rawValue
                    return // failed to encode so bail out
                }

                var request = URLRequest(url: submitReportUrl)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                URLSession.uploadTask(with: request, from: uploadData) { result in
                    switch result {
                    case .failure(let error):
                        os_log(
                            "Uploading signed report (%@) failed: %@",
                            log: .app,
                            type: .error,
                            signatureBytesBase64EncodedString,
                            error as CVarArg
                        )
                        signedReport.uploadState = UploadState.notUploaded.rawValue
                    case .success(let (response, data)):
                        os_log(
                            "Uploaded signed report (%@)",
                            log: .app,
                            signatureBytesBase64EncodedString
                        )
                        signedReport.uploadState = UploadState.uploaded.rawValue

                        if let mimeType = response.mimeType,
                            mimeType == "application/json",
                            let dataString = String(data: data, encoding: .utf8) {
                            print("got data: \(dataString)")
                        }
                    }
                }.resume() // fire request
            }
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.uploadSignedReportsIfNeeded()
    }
    
}

struct ReportUpload: Codable {
    let temporaryContactKeyBytes: Data?
    let startIndex: Int16
    let endIndex: Int16
    let memoData: Data?
    let memoType: Int16
    let signatureBytes: Data?
    let reportVerificationPublicKeyBytes: Data?
}

typealias HTTPResult = Result<(URLResponse, Data), Error>

extension URLSession {
    static func uploadTask(with: URLRequest, from: Data, result: @escaping (HTTPResult) -> Void) -> URLSessionDataTask {
        return URLSession.shared.uploadTask(with: with, from: from) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode), let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
