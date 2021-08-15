//
//  Constants.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation

enum Constants: String {
    
    case jsonObject
    case placeholderImageCacheKey
    case placeholderImageURL = "https://www.minasjr.com.br/wp-content/themes/minasjr/images/placeholders/placeholder_large_dark.jpg"
    
    enum LayoutStyle {
        case pagged
        case smooth
    }
    
    enum Notifications: String {
        case netStatusChange
        case netStatusStartMonitoring
    }
    
    enum CardModelKeys: String {
        case CatId
        case Title
        case STitle
        case Imag
        case Id
        case DataListAddr
    }
    
    enum CategoryModelKeys: String {
        case CatId
        case CTitle
    }
    
    enum JSONFields: String {
        case DataObject
        case DataListCat
        case DataListObject
    }
    
    enum TabCase: String, CaseIterable {
        case allBenefits = "כל ההטבות"
        case recommended = "המומלצים"
        case myPinukim = "הפינוקים שלי"
        case favorites = "המועדפים"
    }
    
    enum CellIds: String {
        case card
        case category
    }
}
