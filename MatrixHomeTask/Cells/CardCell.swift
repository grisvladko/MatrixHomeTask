//
//  CardCell.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.textAlignment = .right
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.textAlignment = .right
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .trailing
        stackView.distribution = .fill
        return stackView
    }()
    
    private var imageView: UIImageView?
    private var imageId: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.removeFromSuperview()
    }
    
    func setup(card: CardModel) {
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            let text = (card.Title + " - " + card.STitle).withBoldText(text: card.Title, boldTextFont: .systemFont(ofSize: 32))
            title.attributedText = text
        } else {
            let text = (card.Title + " - " + card.STitle).withBoldText(text: card.Title)
            title.attributedText = text
        }
        
        loadImage(urlString: card.Imag)
    }
    
    func setupForDebbuging(_ indexPath: IndexPath) {
        self.accessibilityIdentifier = "\(indexPath.row)"
        self.isAccessibilityElement = true
    }
    
    private func setupTitleConstraints() {
        titleStackView.addArrangedSubview(title)
        
        contentView.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    private func loadImage(urlString: String) {
        if let image = Cache.shared.get(urlString as AnyObject) as? UIImage {
            displayImage(image, savingKey: urlString)
            return
        }
        
        ImageLoader.loadImage(urlString: urlString) { [weak self] (result) in
            do {
                let image = try result.get()
                self?.displayImage(image, savingKey: urlString)
            } catch {
                self?.loadPlaceholderImage()
            }
        }
    }
    
    private func loadPlaceholderImage() {
        let key = Constants.placeholderImageCacheKey.rawValue
        if let image = Cache.shared.get(key as AnyObject) as? UIImage {
            displayImage(image, savingKey: key)
            return
        }
        
        ImageLoader.loadImage(urlString: Constants.placeholderImageURL.rawValue) { [weak self] (result) in
            do {
                let image = try result.get()
                self?.displayImage(image, savingKey: key)
            } catch {
                self?.backgroundColor = .red
            }
        }
    }
    
    private func displayImage(_ image: UIImage, savingKey: String) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView = UIImageView(image: image)
            Cache.shared.save(image, for: savingKey as AnyObject, lifetime: 100)
            self?.setupImageConstraints()
        }
    }
    
    private func setupImageConstraints() {
        guard let imageView = imageView else { return }
        contentView.pin(imageView, insets: .zero)
        contentView.bringSubviewToFront(titleStackView)
    }
}

