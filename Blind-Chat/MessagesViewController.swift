//
//  ChatRoomsViewController.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class MessagesViewController: UIViewController {
    
    var user: String!
    var allusers = [String]()
    var messages = [String]()
    let chatManager = ChatAPIManager.shared
    var room: String!
    var numPeopleTyping = [String]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MessagesCell.self, forCellWithReuseIdentifier: "message")
        cv.backgroundColor = FlatWhite()
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = true
        return cv
    }()
    
    let messageInputContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return v
    }()
    
    lazy var messageInputField: UITextField = {
        let f = UITextField()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.delegate = self
        f.backgroundColor = FlatWhite()
        return f
    }()
    
    lazy var sendMessageButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Send", for: [])
        b.setTitleColor(FlatRed(), for: [])
        b.backgroundColor = FlatWhite()
        b.addTarget(self, action: #selector(sendButtonPressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    let messageInputSeperator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = FlatRed()
        return v
    }()
    
    let updatesLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatWhite()
        title = room
        setupViews()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed(sender:)))
    }
    
    var messageInputContainerBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
        joinRoom()
        setupNotifications()
        //listenForMessagesFromOthers()
        getChatHistory()
        listenForRoomMessages()
        listenForTypingUpdates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        leaveRoom()
    }
    
    deinit {
        print("Deinitializing...")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    func setupNotifications() {
        
        // keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    // MARK: - Views
    
    func setupMessageInputFields() {
        view.addSubview(messageInputContainer)
        messageInputContainerBottomConstraint = messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        messageInputContainerBottomConstraint.isActive = true
        messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        messageInputContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageInputContainer.addSubview(messageInputSeperator)
        messageInputSeperator.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 0).isActive = true
        messageInputSeperator.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: 0).isActive = true
        messageInputSeperator.topAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 0).isActive = true
        messageInputSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        messageInputContainer.addSubview(messageInputField)
        messageInputField.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 8).isActive = true
        messageInputField.widthAnchor.constraint(equalTo: messageInputContainer.widthAnchor, multiplier: 0.75).isActive = true
        messageInputField.topAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 6).isActive = true
        messageInputField.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor, constant: -6).isActive = true
        //messageInputField.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor, constant: 0).isActive = true
        
        messageInputContainer.addSubview(sendMessageButton)
        sendMessageButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: 0).isActive = true
        sendMessageButton.topAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 6).isActive = true
        sendMessageButton.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor, constant: -6).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: messageInputContainer.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupCollectionView() {
        
        view.addSubview(updatesLabel)
        updatesLabel.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 0).isActive = true
        updatesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        updatesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        updatesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: updatesLabel.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupViews() {
        setupMessageInputFields()
        setupCollectionView()
    }
    
    // MARK: - API
    
    func joinRoom() {
        chatManager.join(room: room)
    }
    
    func leaveRoom() {
        chatManager.leave(room: room)
    }
    
    func listenForMessagesFromOthers() {
        /*
        chatManager.getMessage { (messageInfo, error) in
            if let error = error {
                print("Error getting message: \(error)")
            } else {
                print("Got message")
                if let msg = messageInfo?["message"] as? String {
                    
                    DispatchQueue.main.async {
                        self.messages.append(msg)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        */
    }
    
    func listenForTypingUpdates() {
        chatManager.listenForTypingUpdates { (user, isTyping, error) in
            if let e = error {
                print(e)
            }
            
            if let username = user {
                DispatchQueue.main.async {
                    if isTyping {
                        print("\(username) is typing...")
                        self.numPeopleTyping.append(username)
                    } else {
                        print("\(username) finished typing...")
                        self.numPeopleTyping = self.numPeopleTyping.filter() {$0 != username}
                    }
                    
                    if self.numPeopleTyping.count == 1 {
                        self.updatesLabel.text = "\(self.numPeopleTyping[0]) is typing..."
                    } else if self.numPeopleTyping.count > 1 {
                        self.updatesLabel.text = "Multiple people are typing..."
                    } else {
                        self.updatesLabel.text = ""
                    }
                }
            }
        }
    }
    
    func listenForRoomMessages() {
        chatManager.getMessages(forRoom: room) { (messageInfo, error) in
            if let _ = error {
                print("Error geting message")
            } else {
                if let msg = messageInfo?["message"] as? String {
                    DispatchQueue.main.async {
                        self.messages.append(msg)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func getChatHistory() {
        chatManager.getChatHistoryFor(room: room) { (messages, error) in
            // messages is supposed to be [[String: String]]
            // Example of single dict in Array:
            // "content": "Message content", "created": "String date", "room": "Swift"
            if let error = error {
                print("Error from chat history callback: \(error)")
            } else {
                // store messages in temp array and then update all on main queue
                var tempArray = [String]()
                for msgDict in messages! {
                    let msg = msgDict["content"]
                    tempArray.append(msg!)
                }
                
                DispatchQueue.main.async {
                    self.messages = tempArray
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getUsers() {
        /*
        ChatAPIManager.shared.connectToServerWithUser(user: user) { (users) in
            print("USERS: \(users.count)")
            print("USERS: \(users)")
            guard let users = users as? [[String: AnyObject]] else {
                print("Problem casting users")
                return
            }
            
            self.allusers = []
            for user in users {
                self.allusers.append(String(describing: user))
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
         */
    }
    
    func refreshButtonPressed(sender: UIBarButtonItem) {
        getUsers()
    }
    
    func send(message: String, forRoom room: String) {
        chatManager.send(message: message, forRoom: room, fromUser: user)
    }
    
    // MARK: - Actions
    
    func sendButtonPressed(sender: UIButton) {
        
        messageInputField.resignFirstResponder()
        if let msg = messageInputField.text, !msg.isEmpty {
            //print("Sending message...")
            send(message: msg, forRoom: room)
            messageInputField.text = ""
        }
        
    }
    
    // MARK: - Keyboard
    
    func handleKeyboardDidShow(notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                messageInputContainerBottomConstraint.constant = -keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    
    func handleKeyboardDidHide(notification: Notification) {
        messageInputContainerBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

}

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if messages.count > 0 {
            scrollToBottom()
        }
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as! MessagesCell
        let message = messages[indexPath.item]
        
        cell.configureCell(forMessage: message)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messages[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        
        //print(estimatedFrame.height)
        if estimatedFrame.height < 50 {
            return CGSize(width: view.frame.width, height: 50)
        }
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height * 1.2)
    }
    
    func scrollToBottom() {
        let delay = Double(NSEC_PER_SEC) * 0.1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay / Double(NSEC_PER_SEC)) {
            let lastIndex = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: lastIndex, at: .top, animated: true)
        }
    }
    
}

extension MessagesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chatManager.sendStartedTypingMessage(byUser: user, fromRoom: room)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        chatManager.sendEndTypingMessage(byUser: user, fromRoom: room)
    }
    
}

