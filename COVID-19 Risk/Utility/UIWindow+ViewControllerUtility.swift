//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

extension UIWindow {
    
    public var topViewController: UIViewController? {
        if var viewController = self.rootViewController {
            while viewController.presentedViewController != nil {
                viewController = viewController.presentedViewController!
            }
            return viewController
        }
        return nil
    }    
}

extension UIViewController {
    
    var visibleViewControllers: [UIViewController] {
        // Special case when self is navigation controller
        if let navigationController = self as? UINavigationController {
            if let lastViewController = navigationController.viewControllers.last {
                return [lastViewController]
            }
        }
        // Recursion part
        if self.children.count > 0 {
            var result = [UIViewController]()
            for childViewController in children {
                result.append(contentsOf: childViewController.visibleViewControllers)
            }
            return result
        }
        return [self]
    }
}

extension UIApplication {
    
    public var topViewController: UIViewController? {
        return (self.connectedScenes.first { $0.delegate is UIWindowSceneDelegate }?.delegate as? UIWindowSceneDelegate)?.window??.topViewController
    }
    
    public var visibleViewControllers: [UIViewController]? {
        #if AppExtension
        return nil
        #else
        var visibleViewControllers = [UIViewController]()
        for scene in self.connectedScenes {
            guard let window = (scene.delegate as? UIWindowSceneDelegate)?.window else { continue }
            if let topViewController = window?.topViewController {
                visibleViewControllers.append(contentsOf: topViewController.visibleViewControllers)
            }
        }
        return visibleViewControllers
        #endif
    }
}
