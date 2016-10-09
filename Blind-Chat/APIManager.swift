//
//  APIManager.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/8/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    func registerUser(user: User, withPassword pwd: String, completion: @escaping (_ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "http://localhost:5000/register")!)
        request.httpMethod = "POST"
        let postString = "username=\(user.username!)&email=\(user.email!)&password=\(pwd)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("error=\(error)")
                return
            }
            if let status = response as? HTTPURLResponse {
                switch status.statusCode {
                case 200:
                    completion(nil)
                case 400:
                    completion("User already exists")
                default:
                    completion("Error creating account")
                }
            }
            
//            let json = try? JSONSerialization.jsonObject(with: data, options: [])
//
//            print(json)
//            guard let jsonToDict = json as? [String: AnyObject] else {
//                completion("Erro creating account")
//                return
//            }
//            
//            guard let responseDict = jsonToDict["response"] as? [String: AnyObject] else {
//                completion("Error creating account")
//                return
//            }
//            
//            if let failure = responseDict["failure"] as? String {
//                completion(failure)
//                return
//            }
//            if let success = responseDict["success"] as? String {
//                completion(nil)
//                return
//            }
            
        }
        task.resume()
        
    }
    
}
