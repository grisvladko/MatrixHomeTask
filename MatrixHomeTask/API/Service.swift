//
//  Service.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation

class Service {
    
    private let queue = DispatchQueue(label: "com.Service", qos: .background, attributes: .concurrent)
    
    func getData(completion: @escaping (Result<Data, Error>) -> Void ) {
        
        queue.async {
            if let path = Bundle.main.path(forResource: Constants.jsonObject.rawValue, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    return completion(.success(data))
                } catch {
                    return completion(.failure(error))
                }
            } else {
                return completion(.failure(NSError(domain: "com.Service", code: 404, userInfo: ["reason": "couldnt make path"])))
            }
        }
    }
}
