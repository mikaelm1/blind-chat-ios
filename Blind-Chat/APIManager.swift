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
    
    private let localhost = APIKeys.localIP
    
    func registerUser(user: User, withPassword pwd: String, completion: @escaping (_ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "http://\(localhost):5000/register")!)
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
            
        }
        task.resume()
    }
    
    func loginUser(username: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "http://\(localhost):5000/login")!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let _ = data, error == nil else {
                print("error=\(error)")
                return
            }
            if let status = response as? HTTPURLResponse {
                switch status.statusCode {
                case 200:
                    completion(nil)
                case 404:
                    completion("Username and password are incorrect")
                default:
                    // db error most likely
                    completion("Error logging in")
                }
            }
        }
        task.resume()
    }
    
}
