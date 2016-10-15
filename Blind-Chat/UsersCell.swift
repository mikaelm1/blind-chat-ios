//
//  UsersCell.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/14/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import ChameleonFramework

class UsersCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = FlatTeal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
