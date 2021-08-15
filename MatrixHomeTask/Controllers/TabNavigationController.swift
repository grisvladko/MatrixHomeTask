//
//  TabNavigationController.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class TabNavigationController: UINavigationController {
    
    private var navButtons: [TabButton] = []
    private var navButtonStack: UIStackView! = nil
    private var currentTab: Constants.TabCase = .allBenefits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        
        #if DEBUG
        setupForDebbuging()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setTabHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.navButtonStack.isHidden = isHidden
        }
    }
    
    private func setNav() {
        guard navButtonStack == nil else {
            self.navButtonStack.isHidden = false
            return
        }
        
        for tab in Constants.TabCase.allCases.reversed() {
            let button = TabButton(tabCase: tab)
            
            button.addTarget(self, action: #selector(handleButtonClick(_:)), for: .touchUpInside)
            navButtons.append(button)
            
            if tab == currentTab { // to start with a highlighted button
                button.handleTap(selected: true)
            } else {
                button.handleTap(selected: false)
            }
        }
        
        navButtonStack = UIStackView(arrangedSubviews: navButtons)
        navButtonStack.translatesAutoresizingMaskIntoConstraints = false
        navButtonStack.alignment = .center
        navButtonStack.spacing = 10
        navButtonStack.axis = .horizontal
        navButtonStack.distribution = .fillEqually

        navigationBar.pin(navButtonStack, insets: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
    }
    
    @objc private func handleButtonClick(_ sender: TabButton) {
        guard let buttonCase = sender.tabCase else { return }
        guard buttonCase != currentTab else { return }
        
        for btn in navButtons {
            if btn.isEqual(sender) {
                btn.handleTap(selected: true)
            } else {
                btn.handleTap(selected: false)
            }
        }
        
        currentTab = buttonCase
        
        if currentTab == .allBenefits || currentTab == .recommended {
            pushSmoothOrPaggedVC()
        } else {
            pushEmptyVC()
        }
    }
    
    private func setupForDebbuging() {
        for i in 0..<navButtons.count {
            navButtons[i].accessibilityIdentifier = "\(i)"
            navButtons[i].isAccessibilityElement = true
        }
    }
    
    private func pushSmoothOrPaggedVC() {
        removeCurrentVC()
        let vc = SmoothOrPaggedViewController()
        vc.setCurrentState(self.currentTab)
        push(vc)
    }
    
    private func pushEmptyVC() {
        removeCurrentVC()
        let vc = EmptyViewController()
        vc.setCurrentState(self.currentTab)
        push(vc)
    }
    
    private func removeCurrentVC() {
        let currentVC = viewControllers.first!
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            currentVC.view.alpha = 0
        }) { (finished) in
            currentVC.removeFromParent()
        }
    }
    
    private func push(_ vc: UIViewController) {
        vc.view.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            vc.view.alpha = 1.0
        }
        self.pushViewController(vc, animated: true)
    }
    
}
