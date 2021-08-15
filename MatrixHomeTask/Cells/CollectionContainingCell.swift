//
//  CollectionContainingCell.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyrigh	t © 2021 hyperactive. All rights reserved.
//

import UIKit



class CollectionContainingCell: UITableViewCell {
    
    private var layoutStyle: Constants.LayoutStyle?
    private var collectionView: UICollectionView?
    fileprivate var cellDelegate: CellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView?.removeFromSuperview()
        collectionView = nil
        cellDelegate = nil
        layoutStyle = nil
    }
    
    func setup(
        _ layoutStyle: Constants.LayoutStyle,
        category: CategoryModel,
        navigationDelegate: NavigationDelegate?) {
        
        guard collectionView == nil,
            cellDelegate == nil else { return }
        
        self.layoutStyle = layoutStyle
        let layout = configureLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView!.backgroundColor = .white
        collectionView!.register(CardCell.self, forCellWithReuseIdentifier: Constants.CellIds.card.rawValue)
        collectionView!.semanticContentAttribute = .forceRightToLeft
        if layoutStyle == .pagged { collectionView!.decelerationRate = .fast }
        
        cellDelegate = CellDelegate(category, navDelegate: navigationDelegate)
        
        collectionView!.delegate = cellDelegate
        collectionView!.dataSource = cellDelegate
        
        contentView.pin(collectionView!, insets: .zero)
    }
    
    func setupForDebbuging(_ indexPath: IndexPath) {
        self.accessibilityIdentifier = "\(indexPath.section)"
        self.isAccessibilityElement = true
        collectionView!.accessibilityIdentifier = "\(indexPath.section)"
        collectionView!.isAccessibilityElement = true
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        guard let layoutStyle = layoutStyle else { return UICollectionViewFlowLayout() }
        switch layoutStyle {
            case .pagged: return PaggedFlowLayout()
            case .smooth: return SmoothFlowLayout()
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        return CGSize(width: layout.collectionViewContentSize.width + 50, height: layout.itemSize.height + 50)
    }
    
}

protocol NavigationDelegate: class {
    func navigate(to card: CardModel, categoryName: String)
}

fileprivate class CellDelegate: NSObject ,UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let category: CategoryModel
    private weak var navigationDelegate: NavigationDelegate?
    
    init(_ category: CategoryModel, navDelegate: NavigationDelegate?) {
        self.category = category
        self.navigationDelegate = navDelegate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.cardModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.card.rawValue, for: indexPath) as! CardCell
        cell.isUserInteractionEnabled = true
        cell.setup(card: category.cardModels[indexPath.row])
        
        #if DEBUG
        cell.setupForDebbuging(indexPath)
        #endif
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationDelegate?.navigate(to: category.cardModels[indexPath.row], categoryName: category.CTitle)
    }

}
