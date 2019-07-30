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
    
    public static var userID: String = ""
    
    class func getArtworkByLocation(latitude: Double, longitude: Double, completion: @escaping (Result<[Artwork], Error>) -> ()) {
        
        let urlString = self.endPoint + self.userPath + "/getArtsByLocation?" + "lat=" + String(latitude) + "&lng=" + String(longitude)
        guard let url = URL(string: urlString) else { return }
        
        get(url: url, completion: completion)

    }
    
    class func searchUsers(str: String, completion: @escaping (Result<[Artist], Error>) -> ()) {
        let urlString = self.endPoint + self.userPath + "/search?" + "str=" + "\(str)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: encodedUrlString) else { return }
        
        get(url: url, completion: completion)
    }
    
    class func getProfileById(id: String, completion: @escaping (Result<Artist, Error>) -> ()) {
        if self.userID != "" {
            let urlString = self.endPoint + self.userPath + "/getProfileById?" + "id=" + id
            guard let url = URL(string: urlString) else { return }
            
            get(url: url, completion: completion)
        }
    }
    
    class func signInApp(id: String, name: String, pictureUrl: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let urlString = self.endPoint + self.userPath + "/signInApp?" + "id=" + id + "&name=" + name + "&picture=" + pictureUrl
        
        getNonJSON(urlString: urlString, completion: completion)
    }
    
    class func likeArtwork(artworkId: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        let urlString = self.endPoint + self.userPath + "/likeArtwork?" + "artworkId=" + "\(artworkId)" + "&userId=" + self.userID
        
        getNonJSON(urlString: urlString, completion: completion)
    }
    
    class func unlikeArtwork(artworkId: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        let urlString = self.endPoint + self.userPath + "/unlikeArtwork?" + "artworkId=" + "\(artworkId)" + "&userId=" + self.userID
        
        getNonJSON(urlString: urlString, completion: completion)
    }
    
    class func getNonJSON<T>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: encodedUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            if let err = err {
                completion(.failure(err))
                return
            }
            if let genData = data as? T {
                completion(.success(genData))
            } else {
                guard let bool = Bool(String(data: data!, encoding: String.Encoding.ascii) ?? "false") as? T else { return }
                completion(.success(bool))
            }
            
        }.resume()
    }
    
    private class func get<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
         
             if let err = err {
                 completion(.failure(err))
                 return
             }
            
             do {
                print(data!)
                let genData = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(genData))
             } catch let jsonError {
                completion(.failure(jsonError))
             }
         }.resume()

    }
    
}
