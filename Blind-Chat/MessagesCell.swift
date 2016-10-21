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
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0 
        return l
    }()
    
    let usernameAndDateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profile_placeholder")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let seperator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = FlatBlue()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = FlatWhite()
        setupViews()
    }
    
    override func layoutSubviews() {
        layoutIfNeeded()
    }
    
    func configureCell(forMessage message: Message) {
        messageLabel.text = message.content
        
        // setup the username and date label
        var attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: message.author, attributes: attributes)
        attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        let lighterString = NSMutableAttributedString(string: message.created, attributes: attributes)
        let spaces = NSMutableAttributedString(string: "  ")
        attributedString.append(spaces)
        attributedString.append(lighterString)
        
        usernameAndDateLabel.attributedText = attributedString
    }
    
    func setupViews() {
        
        addSubview(seperator)
        seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        seperator.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(profileImage)
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        profileImage.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(usernameAndDateLabel)
        usernameAndDateLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
        usernameAndDateLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8).isActive = true
        usernameAndDateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        usernameAndDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        messageLabel.topAnchor.constraint(equalTo: usernameAndDateLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
