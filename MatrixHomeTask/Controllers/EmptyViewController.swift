//
//  EmptyViewController.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    
    private var currentState: Constants.TabCase = .myPinukim // default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmptyTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    func setCurrentState(_ newState: Constants.TabCase) {
        currentState = newState
    }
    
    private func setEmptyTab() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .blue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = currentState.rawValue
        
        view.backgroundColor = .lightGray
        view.pin(label, insets: .zero)
    }
}
