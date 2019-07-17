//
//  RestController.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class RestController: NSObject {

    static let endPoint: String = "http://project-dali.com:5000"
    static let userPath: String = "/user"
    static let systemPath: String = "/system"
    static let mlPath: String = "/ML"
    
    class func getArtworkByLocation(latitude: Double, longitude: Double, completion: @escaping (Result<[Artwork], Error>) -> ()) {
        
        let urlString = self.endPoint + self.userPath + "/getArtsByLocation?" + "lat=" + String(latitude) + "&lng=" + String(longitude)
        guard let url = URL(string: urlString) else { return }
        
        get(url: url, completion: completion)

    }
    
    private class func get<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()){
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
         
             if let err = err {
                 completion(.failure(err))
                 return
             }
            
             do {
                let genData = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(genData))
             } catch let jsonError {
                completion(.failure(jsonError))
             }
         }.resume()

    }
    
}
