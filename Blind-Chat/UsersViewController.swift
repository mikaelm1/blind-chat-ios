//
//  ChatRoomsViewController.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class UsersViewController: UIViewController {
    
    var user: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = FlatWhite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers()
    }
    
    func getUsers() {
        ChatAPIManager.shared.connectToServerWithUser(user: user) { (users) in
            print("USERS: \(users)")
        }
    }

}
