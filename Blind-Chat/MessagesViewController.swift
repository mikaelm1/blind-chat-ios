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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MessagesCell.self, forCellWithReuseIdentifier: "users")
        cv.backgroundColor = FlatWhite()
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = true
        return cv
    }()
    
    let messageInputContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = FlatWhite()
        return v
    }()
    
    let messageInputField: UITextField = {
        let f = UITextField()
        f.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatWhite()
        title = "Users"
        setupViews()
        
        messages = Array(repeating: "Message", count: 100)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed(sender:)))
    }
    
    var messageInputContainerBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers()
        setupNotifications()
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
        messageInputField.widthAnchor.constraint(equalTo: messageInputContainer.widthAnchor, multiplier: 0.8).isActive = true
        messageInputField.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor, constant: 0).isActive = true
        
        messageInputContainer.addSubview(sendMessageButton)
        sendMessageButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: 0).isActive = true
        sendMessageButton.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor, constant: 0).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: messageInputContainer.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupViews() {
        setupMessageInputFields()
        setupCollectionView()
    }
    
    // MARK: - API
    
    func getUsers() {
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
    }
    
    func refreshButtonPressed(sender: UIBarButtonItem) {
        getUsers()
    }
    
    func send(message: String) {
        chatManager.sendMessage(message: message, user: user)
    }
    
    // MARK: - Actions
    
    func sendButtonPressed(sender: UIButton) {
        print("Sending message...")
        messageInputField.resignFirstResponder()
        if let msg = messageInputField.text, !msg.isEmpty {
            send(message: msg)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "users", for: indexPath) as! MessagesCell
        let message = messages[indexPath.row]
        
        if indexPath.item % 2 == 0 {
            cell.configureCell(forMessage: message, fromCurrentUser: false)
        } else {
            cell.configureCell(forMessage: message, fromCurrentUser: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func scrollToBottom() {
        let delay = Double(NSEC_PER_SEC) * 0.1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay / Double(NSEC_PER_SEC)) {
            let lastIndex = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: lastIndex, at: .top, animated: true)
        }
    }
    
}

