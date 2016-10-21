//
//  Message.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/21/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

class Message {
    
    var content: String!
    var room: String!
    var author: String!
    var created: String!
    
    init(messageDict dict: [String: String]) {
        if let content = dict["content"] {
            self.content = content
        }
        
        if let room = dict["room"] {
            self.room = room
        }
        
        if let username = dict["username"] {
            self.author = username
        }
        
        if let created = dict["created"] {
            
            let interval = NSString(string: created).doubleValue
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            let date = Date(timeIntervalSince1970: interval)
            let dateString = formatter.string(from: date)
            self.created = "\(dateString)"
            
        }
    }
    
}
