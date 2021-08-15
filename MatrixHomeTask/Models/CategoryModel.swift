//
//  CategoryModel.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation

struct CategoryModel : Comparable {
    
    static func < (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.CatId < rhs.CatId
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.CatId == rhs.CatId
    }
    
    let CatId: UInt
    let CTitle: String
    var cardModels: [CardModel] = []
}
