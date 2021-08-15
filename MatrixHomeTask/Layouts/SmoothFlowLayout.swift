//
//  ss.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class SmoothFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        let itemDim: CGFloat = UIScreen.main.bounds.width / 2.3
        scrollDirection = .horizontal
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        itemSize = CGSize(width: itemDim , height: itemDim)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        
        // This check is helpfull to prevent calculations when hitting the end of the screen, on either side.
        if proposedContentOffset.x == 0 || proposedContentOffset.x == collectionView.contentSize.width - UIScreen.main.bounds.width{
            return proposedContentOffset
        }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let rightEdge = proposedContentOffset.x + collectionView.frame.width
        
        for attrs in rectAttributes {
            let itemRightEdge = attrs.frame.maxX
            if (itemRightEdge - (rightEdge - itemSize.width - minimumLineSpacing)).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = (itemRightEdge - (rightEdge - itemSize.width - minimumLineSpacing))
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}


