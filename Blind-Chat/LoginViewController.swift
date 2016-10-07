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
    
    let passwordField: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = FlatWhite()
        t.placeholder = "Enter password"
        return t
    }()
    
    let usernameField: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = FlatWhite()
        t.placeholder = "Enter username"
        return t
    }()
    
    lazy var loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = FlatMint()
        b.setTitle("Login", for: [])
        b.addTarget(self, action: #selector(loginButtonTapped(sender:)), for: .touchUpInside)
        b.setTitleColor(FlatWhite(), for: [])
        return b
    }()
    
    let chatManager = ChatAPIManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = FlatBlue()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        view.addSubview(usernameField)
        usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func loginButtonTapped(sender: UIButton) {
        
        ChatAPIManager.shared.connectToServerWithUser(user: "Becca") { (users) in
            print("USERS: \(users)")
        }
    }

}

