//
//  ViewController.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework 

class LoginViewController: UIViewController {
    
    let chatManager = ChatAPIManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatGreen()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
    }

    @IBOutlet weak var joinChat: UIButton!
    
    @IBAction func joinChat(sender: UIButton) {
        
        ChatAPIManager.shared.connectToServerWithUser(user: "Becca") { (users) in
            print("USERS: \(users)")
        }
    }

}

