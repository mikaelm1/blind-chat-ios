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
            if let users = users[0] as? [Any] {
                completion(users)
            } else {
                print("Still not working")
            }
        }

    }
    
    func sendMessage(message: String, user: String) {
        print("In chatmanager sending message: \(message). For user \(user)")
        socket.emit("chatMessage", message, user)
    }
    
    func getMessage(completion: @escaping (_ messageInfo: [String: AnyObject]?, _ error: String?) -> Void) {
        
        socket.on("newChatMessage") { (msgArray, ack) in
            print("CHAT MESSAGE DICT: \(msgArray)")
            if let msgDict = msgArray[0] as? [String: AnyObject] {
                completion(msgDict, nil)
            } else {
                completion(nil, "Error getting message")
            }
            
        }
    }
    
    func openConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
