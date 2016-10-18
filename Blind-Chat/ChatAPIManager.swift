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
    
    var socket = SocketIOClient(socketURL: URL(string: "http://\(APIKeys.localIP):5000")!)
    
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
    
    func join(room: String) {
        print("Inside join room: \(room)")
        let data = ["room": room]
        socket.emit("join", data)
    }
    
    func leave(room: String) {
        print("Inside leave room: \(room)")
        let data = ["room": room]
        socket.emit("leave", data)
    }
    
    /// sends message to a particular room
    func send(message: String, room: String) {
        let data = ["message": message, "room": room]
        socket.emit("room_message", data)
    }
    
    /// sends message to everyone
    func sendMessage(message: String, user: String) {
        print("In chatmanager sending message: \(message). For user \(user)")
        socket.emit("chatMessage", message, user)
    }
    
    /// listen for broodcast messages
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
    
    /// Listens for room messages
    func getMessages(forRoom room: String, completion: @escaping (_ messageInfo: [String: AnyObject]?, _ error: String?) -> Void) {
        
        socket.on("new_room_message") { (msgArray, ack) in
            print("Chat Dict for room \(room): \(msgArray)")
            if let msgDict = msgArray[0] as? [String: AnyObject] {
                completion(msgDict, nil)
            } else {
                completion(nil, "Error getting message")
            }
        }
    }
    
    func getChatHistoryFor(room: String, completion: @escaping (_ messages: [[String: String]]?, _ error: String?) -> Void) {
        print("Inside chat hsitory for room: \(room)")
        socket.on("room_messages") { (data, _) in
            print("Got message history for room \(room)")
            print("Messages: \(data[0])")
            
            guard let messagesArray = data[0] as? [String: AnyObject] else {
                completion(nil, "Error converting messages")
                return
            }
            
            guard let messagesArrayOfDicts = messagesArray["messages"] as? [[String: String]] else {
                completion(nil, "Error parsing messages")
                return
            }
            completion(messagesArrayOfDicts, nil)
        }
    }
    
    func openConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
