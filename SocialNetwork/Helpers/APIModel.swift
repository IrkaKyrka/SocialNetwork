//
//  APIModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/31/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import Foundation


class APIModel {
    
    let userId = 21212138
    let token = "1eb743b150754e265b05543cc0f4160b7ff8c300c105556a0c1d861460ccd8ebec684eedf4dfd54b4b7e2"
    
    
    func getData(method: String, params: [String:String], completion: @escaping (_ data: Data) -> Void) {
        
        var urlComponents = URLComponents()
        var query = ""
        
        for (key, value) in params{
            query += "\(key)=\(value)&"
        }
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/\(method)"
        urlComponents.query = "\(query)access_token=\(token)&v=5.92"
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            completion(data)
            }.resume()
    }
    
    func postData(method: String, userId: Int, message: String, completion: @escaping (_ error: Error?) -> Void) {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.post"
        urlComponents.query = "owner_id=\(userId)&message=\(message)&access_token=\(token)&v=5.92"
       
        guard let url = urlComponents.url else {return}
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            completion(error)
            
            }.resume()
    }
}
