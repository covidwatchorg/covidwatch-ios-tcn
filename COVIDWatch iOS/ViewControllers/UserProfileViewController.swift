//
//  Created by Zsombor Szabo on 14/03/2020.
//
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var isCurrentUserSickCanceller: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCurrentUserSickCanceller = UserDefaults.standard.observe(\.isCurrentUserSick, options: [.initial, .new], changeHandler: { [weak self] (_,_) in
            guard let self = self else { return }
            self.view.backgroundColor = UserDefaults.standard.isCurrentUserSick ? .systemRed : .systemGreen
        })
    }

    @IBAction func handleTapNoButton(_ sender: UIButton) {
        UserDefaults.standard.isCurrentUserSick = false
    }
    
    @IBAction func handleTapYesButton(_ sender: UIButton) {
        UserDefaults.standard.isCurrentUserSick = true
    }

}

