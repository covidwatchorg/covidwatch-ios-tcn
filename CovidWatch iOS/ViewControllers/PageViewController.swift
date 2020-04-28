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
    var index = 0
    
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
        
        //full screen
        self.modalPresentationStyle = .fullScreen
        
        self.items = HowItWorks.createAll(delegate: self)
        if let first = self.items.first {
            self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
        delegate = self
    }
}

// MARK: - Protocol HowItWorksDelegate
extension PageViewController: HowItWorksDelegate {
    func indexWasRequested(index: Int) {
        guard index != self.index else {
            print("Same Index.  Returning Early. Tapped: \(index) Current: \(self.index)")
            return
        }
    
        guard index >= 0 && index < self.items.count else {
            assertionFailure("Invalid index. \(index)")
            return
        }
        let direction: UIPageViewController.NavigationDirection = index > self.index ? .forward : .reverse
        let viewController = self.items[index]
        self.index = index
        self.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
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

// MARK: - Protocol UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
            let index = pageViewController.viewControllers?.first?.view.tag {
            // converting 1 based from how it works to 0 based
            self.index = index - 1
            print("Set Index From Slide to \(self.index)")
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
