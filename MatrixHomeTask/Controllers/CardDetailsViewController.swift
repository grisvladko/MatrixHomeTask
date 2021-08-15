//
//  CardViewController.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setShadow(radius: 4.0)
        return label
    }()
    
    private let cardId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var stackConstraints : [NSLayoutConstraint] = []
    
    private var imageHeightConst: NSLayoutConstraint?
    private var imageWidthConst: NSLayoutConstraint?
    private var imageView: UIImageView?
    private var titleStack: UIStackView!
    var card: CardModel?
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        edgesForExtendedLayout = []
        
        guard let card = card , let categoryName = categoryName else { return }
        setupLabels(card, categoryName)
        setupImage(card)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = navigationController as? TabNavigationController {
            nav.setTabHidden(true)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        for constraint in stackConstraints {
            constraint.isActive = false
            constraint.isActive = true
        }
    }
    
    private func setupLabels(_ card: CardModel, _ categoryName: String) {
        titleStack = UIStackView(arrangedSubviews: [titleLabel, cardId])
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleStack)
        
        titleStack.alignment = .center
        titleStack.axis = .vertical
        titleStack.spacing = 5
        titleStack.distribution = .fill
        
        titleLabel.setOutline(with: categoryName, color: .goldenTitle, strokeWidth: -3.0)
        cardId.text = "\(card.Id)"
        
        if traitCollection.horizontalSizeClass == .compact {
            titleLabel.font = .boldSystemFont(ofSize: 32)
            cardId.font = .boldSystemFont(ofSize: 16)
        } else {
            titleLabel.font = .boldSystemFont(ofSize: 40)
            cardId.font = .boldSystemFont(ofSize: 26)
        }
        
        stackConstraints = [
            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
    }
    
    private func setupImage(_ card: CardModel) {
        var obj = Cache.shared.get(card.Imag as AnyObject)
        
        if obj == nil {
            obj = Cache.shared.get(Constants.placeholderImageCacheKey.rawValue as AnyObject)
        }
        
        if let image = obj as? UIImage {
            imageView = UIImageView(image: image)
            
            titleStack.addArrangedSubview(imageView!)
        }
    }
}

