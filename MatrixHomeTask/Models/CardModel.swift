//
//  CardModel.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation

struct CardModel : Comparable {
    
    static func < (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.CatId < rhs.CatId
    }
    
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.CatId == rhs.CatId && lhs.STitle == rhs.STitle && lhs.Id == rhs.Id
    }
    
    let CatId: UInt
    let Title: String
    let STitle: String
    let Imag: String
    let Id: UInt
    let DataListAddr: [Any]
}
