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
    
    func registerUser(user: User, withPassword pwd: String, completion: @escaping (_ error: Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "http://localhost:5000/register")!)
        request.httpMethod = "POST"
        let postString = "username=\(user.username!)&email=\(user.email!)&password=\(pwd)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            if let status = response as? HTTPURLResponse {
                print(status.statusCode)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")

        }
        task.resume()
        
    }
    
}
