//
//  PageViewController.swift
//  CovidWatch iOS
//
//  Created by Jeff Lett on 4/27/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    var items: [UIViewController]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        commonInit()
    }
    
    private func commonInit() {
        //white background if you scroll past the last items
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = .white
        view.insertSubview(bgView, at: 0)
        
        self.modalPresentationStyle = .fullScreen
        let storyboard = UIStoryboard(name: "\(HowItWorks.self)", bundle: nil)
        
        var viewControllers = [UIViewController]()
        for i in 1...HowItWorks.numPages {
            let identifier = "\(HowItWorks.self)\(i)"
            if let howItWorks = storyboard.instantiateViewController(identifier: identifier) as? HowItWorks {
                howItWorks.delegate = self
                viewControllers.append(howItWorks)
            }
        }
        
        self.items = viewControllers
        if let first = self.items.first {
            self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
    }
}

// MARK: - Protocol HowItWorksDelegate
extension PageViewController: HowItWorksDelegate {
    func btnTapped() {
        // this assumes that we will have a navigation controller
        // during onboarding, and that we won't have one from the
        // menu
        if self.navigationController != nil {
            self.performSegue(withIdentifier: "\(Bluetooth.self)", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Protocol UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0,
            items.count > previousIndex else {
            return nil
        }
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex,
            items.count > nextIndex else {
            return nil
        }
        return items[nextIndex]
    }
    
}
