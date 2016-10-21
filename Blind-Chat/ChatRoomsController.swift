//
//  ChatRoomsController.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/14/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class ChatRoomsController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(RoomsCell.self, forCellWithReuseIdentifier: "rooms")
        cv.backgroundColor = FlatBlue()
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = true
        return cv
    }()
    
    var rooms = ["Swift", "Python", "C++", "Brainfuck", "JavaScript", "Ruby", "Java", "C", "C#", "PHP", "Objective-C", "R", "Haskell", "Erlang"]
    var user: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rooms"
        
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.barTintColor = FlatMint()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatWhite()]
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func gotoChat(room: String) {
        let vc = MessagesViewController()
        vc.user = user
        vc.room = room
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChatRoomsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rooms", for: indexPath) as! RoomsCell
        let room = rooms[indexPath.item]
        cell.configureCell(forRoom: room)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let room = rooms[indexPath.item]
        gotoChat(room: room)
    }
    
}
