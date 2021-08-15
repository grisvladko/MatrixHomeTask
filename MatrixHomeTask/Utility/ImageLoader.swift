//
//  ImageLoader.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

struct ImageLoader {
    
    static func loadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void ) {
        
        guard let url = URL(string: urlString) else { return completion(.failure(NSError())) }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, err) in
            if let err = err {
                return completion(.failure(err))
            }
            guard let data = data else { return completion(.failure(NSError())) }
            guard let image = UIImage(data: data) else { return completion(.failure(NSError())) }
            return completion(.success(image))
        }
        
        task.resume()
    }
}
