//
//  JSONParser.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation

class JSONParser {
    
    var dataListCat: [CategoryModel] = []
    var dataListObject: [CardModel] = []
    private let externalKey = Constants.JSONFields.self
    
    func parse(json: Data) -> Result<(dataListCat: [CategoryModel], dataListObject: [CardModel]), Error> {
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: json, options: .mutableLeaves)
            if let dict = jsonResult as? Dictionary<String, Any> { getDataObject(dict: dict) }
        } catch {
            return .failure(error)
        }
        
        saveToCache()
        return .success((dataListCat: dataListCat, dataListObject: dataListObject))
    }
    
    private func saveToCache() {
        Cache.shared.save(dataListCat as AnyObject,
                          for: Constants.JSONFields.DataListCat.rawValue as AnyObject,
                          lifetime: 1000)
        Cache.shared.save(dataListObject as AnyObject,
                          for: Constants.JSONFields.DataListObject.rawValue as AnyObject,
                          lifetime: 1000)
    }
    
    private func getDataObject(dict: Dictionary<String, Any>) {
        if let dataObject = dict[externalKey.DataObject.rawValue] as? Dictionary<String, Any> {
            getDataListCat(dict: dataObject)
            getDataListObject(dict: dataObject)
        }
    }
    
    private func getDataListCat(dict: Dictionary<String, Any>) {
        if let dataListCat = dict[externalKey.DataListCat.rawValue] as? Array<Any> {
            parseDataListCat(dataListCat)
        }
    }
    
    private func getDataListObject(dict: Dictionary<String, Any>) {
        if let dataListObject = dict[externalKey.DataListObject.rawValue] as? Array<Any> {
            parseDataListObject(dataListObject)
        }
    }
    
    private func parseDataListCat(_ dataListCat: Array<Any>) {
        let catKeys = Constants.CategoryModelKeys.self
        
        for item in dataListCat {
            if let dict = item as? Dictionary<String, Any> {
                let categoryModel = CategoryModel(
                    CatId: dict[catKeys.CatId.rawValue] as? UInt ?? 0,
                    CTitle: dict[catKeys.CTitle.rawValue] as? String ?? "")
                
                self.dataListCat.append(categoryModel)
            }
        }
    }
    
    private func parseDataListObject(_ dataListObject: Array<Any> ) {
        let cardKeys = Constants.CardModelKeys.self
        
        for item in dataListObject {
            if let dict = item as? Dictionary<String, Any> {
                let cardModel = CardModel(
                    CatId: dict[cardKeys.CatId.rawValue] as? UInt ?? 0,
                    Title: dict[cardKeys.Title.rawValue] as? String ?? "" ,
                    STitle: dict[cardKeys.STitle.rawValue] as? String ?? "" ,
                    Imag: dict[cardKeys.Imag.rawValue] as? String ?? "" ,
                    Id: dict[cardKeys.Id.rawValue] as? UInt ?? 0,
                    DataListAddr: dict[cardKeys.DataListAddr.rawValue] as? [Any] ?? [])
                
                self.dataListObject.append(cardModel)
            }
        }
    }
}
