//
//  RoomsCell.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/14/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class RoomsCell: UICollectionViewCell {
    
    let roomNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = FlatRed()
        setupViews()
    }
    
    func setupViews() {
        addSubview(roomNameLabel)
        
        roomNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        roomNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    func configureCell(forRoom room: String) {
        roomNameLabel.text = room
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
