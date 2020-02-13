//
//  URLSeesionExtension.swift
//  Astronomy
//
//  Created by Craig Swanson on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let loadDataTask = dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        loadDataTask.resume()
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let loadDataTask = dataTask(with: url) { (possibleData, _, possibleError) in
            completion(possibleData, possibleError)
        }
        loadDataTask.resume()
    }
    
    
}
