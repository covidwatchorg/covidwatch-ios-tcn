//
//  Created by Zsombor Szabo on 31/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var appDelegate: AppDelegate {
     return UIApplication.shared.delegate as! AppDelegate
    }
    var clockTimer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.text = (appDelegate.logV.map { ll in ll.line }).joined(separator: "\n") + "\n"
        appDelegate.logViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.clock.text = LogLine.formatD(Date())
        }
        clockTimer!.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clockTimer?.invalidate()
        appDelegate.logViewController = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    func log(_ s: String) {
        textView?.text += s + "\n"
    }
    
    
    @IBAction func logButtonPressed(_ sender: Any) {
        appDelegate.log("l")
    }
    @IBAction func exitPressed(_ sender: Any) {
        exit(0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
