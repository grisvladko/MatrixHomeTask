//
//  MatrixHomeTaskTests.swift
//  MatrixHomeTaskTests
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import XCTest
@testable import MatrixHomeTask

class MatrixHomeTaskTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: TESTING ALL THE WAY TO THE JSON OBJECT,
    
    
    func test_invoke_Service() throws {
        test_Service { (error) in
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_Service(_ completion: @escaping (_ error: Error) -> Void) {
        let service = Service()
        
        service.getData { (result) in
            do {
                let data = try result.get()
                let json = try self.test_Parser(data)
                try self.test_JSON(json)
            } catch {
                completion(error)
            }
        }
    }
    
    func test_Parser(_ data: Data) throws -> (dataListCat: [CategoryModel], dataListObject: [CardModel]) {
        let parser = JSONParser()
        
        let result = parser.parse(json: data)
        
        do {
            let json = try result.get()
            return json
        } catch {
            throw error
        }
    }
    
    func test_JSON(_ json: (dataListCat: [CategoryModel], dataListObject: [CardModel] )) throws {
        try test_CardModel(cards: json.dataListObject)
    }
    
    
    /*
     FOR TESTING PURPOSES ITS HERE
     "CatId": 4,
     "Title": "לה פאצ'ה - חד נס",
     "STitle": "אירוח בצימר בהנחה מיוחדת",
     "Imag": "https://www.leumi-card.co.il/he-il/Benefits/LeumiCard/PublishingImages/Tzimerim/LaPacha/LaPacha_big.min.jpg",
     "Id": 103686,
     "DataListAddr": [
     {
     "DAd": "חד נס"
     }
     ]
     */
    
    func test_CardModel(cards: [CardModel]) throws {
        let testCardModel = CardModel(CatId: 4,
                                      Title: "לה פאצ'ה - חד נס",
                                      STitle: "אירוח בצימר בהנחה מיוחדת",
                                      Imag: "https://www.leumi-card.co.il/he-il/Benefits/LeumiCard/PublishingImages/Tzimerim/LaPacha/LaPacha_big.min.jpg",
                                      Id: 103686,
                                      DataListAddr: [])
        var isEqual = false
        for card in cards {
            if card == testCardModel {
                isEqual = true
                break
            }
        }
        
        XCTAssertTrue(isEqual)
    }
    
    /*
     {"CatId":1 ,"CTitle":"קטגוריה 1"}
     */
    
    func test_CategoryModel(categories: [CategoryModel]) throws {
        let testCategoryModel = CategoryModel(CatId: 1, CTitle: "קטגוריה 1")
        
        var isEqual = false
        for cat in categories {
            if cat == testCategoryModel {
                isEqual = true
                break
            }
        }
        
        XCTAssertTrue(isEqual)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
