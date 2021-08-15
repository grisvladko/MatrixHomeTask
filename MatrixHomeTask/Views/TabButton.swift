//
//  TabButton.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class TabButton: UIButton {
    
    var tabCase: Constants.TabCase?
    private let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tabButtonSelected
        return view
    }()
    
    func handleTap(selected: Bool) {
        if selected {
            setTitleColor( .tabButtonSelected, for: .normal)
        } else {
            setTitleColor( .tabButtonUnselected , for: .normal)
        }
        
        toggleBorder(show: selected)
    }
    
    convenience init(tabCase: Constants.TabCase) {
        self.init(frame: .zero)
        self.tabCase = tabCase
        
        titleLabel?.numberOfLines = 1
        titleLabel?.allowsDefaultTighteningForTruncation = true
        titleLabel?.textAlignment = .center
        if let font = setFont() {
            titleLabel?.font = font
        }
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        setTitle(tabCase.rawValue, for: .normal)
        setTitleColor(.black, for: .normal)
        
        addSelectedUndeline()
    }
    
    private func setFont() -> UIFont? {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            return nil
        } else {
            return .systemFont(ofSize: 32, weight: .bold)
        }
    }
    
    private func addSelectedUndeline() {
        addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    private func toggleBorder(show: Bool) {
        if show {
            bottomBorder.alpha = 1.0
        } else {
            bottomBorder.alpha = 0.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

