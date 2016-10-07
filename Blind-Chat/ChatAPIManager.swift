//
//  ChatAPIManager.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import SocketIO

class ChatAPIManager: NSObject {
    
    static let shared = ChatAPIManager()
    
    var socket = SocketIOClient(socketURL: URL(string: "http://127.0.0.1:5000")!)
    
    override init() {
        super.init()
        
    }
    
    func connectToServerWithUser(user: String, completion: @escaping (_ userList: [Any]) -> Void) {
        
        socket.emit("connectUser", user)
        print("Emitted connectUser")
        socket.on("userList") { (users, ack) in
            print("Inside userList ")
            completion(users)
        }

        
    }
    
    func openConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
