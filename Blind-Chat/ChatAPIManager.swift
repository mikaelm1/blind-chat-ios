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
        //print("Inside join room: \(room)")
        let data = ["room": room]
        socket.emit("join", data)
    }
    
    func leave(room: String) {
        //print("Inside leave room: \(room)")
        let data = ["room": room]
        socket.emit("leave", data)
    }
    
    /// sends message to a particular room
    func send(message: String, forRoom room: String, fromUser user: String) {
        let data = ["message": message, "room": room, "user": user]
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
            //print("CHAT MESSAGE DICT: \(msgArray)")
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
            //print("Chat Dict for room \(room): \(msgArray)")
            if let msgDict = msgArray[0] as? [String: AnyObject] {
                completion(msgDict, nil)
            } else {
                completion(nil, "Error getting message")
            }
        }
    }
    
    /// Let server know that user is typing
    func sendStartedTypingMessage(byUser user: String, fromRoom room: String) {
        let data = ["room": room, "username": user]
        socket.emit("start_typing_in_room", data)
    }
    
    /// Let server know that user finished typing
    func sendEndTypingMessage(byUser user: String, fromRoom room: String) {
        let data = ["room": room, "username": user]
        socket.emit("end_typing_in_room", data)
    }
    
    /// Find out which user is typing
    func listenForTypingUpdates(completion: @escaping(_ user: String?, _ typing: Bool, _ error: String?) -> Void) {
        
        socket.on("started_typing") { (data, ack) in
            //print("Inside started_typing")
            guard let userInfo = data[0] as? [String: AnyObject] else {
                completion(nil, false, "Error parsing username")
                return
            }
            
            if let username = userInfo["user"] as? String {
                completion(username, true, nil)
            }
        }
        
        socket.on("ended_typing") { (data, ack) in
            print("Inside ended typing")
            guard let userInfo = data[0] as? [String: AnyObject] else {
                completion(nil, false, "Error parsing user info")
                return
            }
            
            if let username = userInfo["user"] as? String {
                completion(username, false, nil)
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
