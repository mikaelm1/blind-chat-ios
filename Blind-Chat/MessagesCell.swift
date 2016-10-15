//
//  UsersCell.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/14/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class MessagesCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func configureCell(forMessage message: String, fromCurrentUser: Bool) {
        messageLabel.text = message
        if fromCurrentUser {
            messageLabel.textAlignment = .right
            backgroundColor = FlatGray()
        } else {
            messageLabel.textAlignment = .left
            backgroundColor = FlatWhite()
        }
    }
    
    func setupViews() {
        addSubview(messageLabel)
        
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
