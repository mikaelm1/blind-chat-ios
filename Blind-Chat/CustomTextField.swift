//
//  CustomTextField.swift
//  Blind-Chat
//
//  Created by Mikael Mukhsikaroyan on 10/19/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        translatesAutoresizingMaskIntoConstraints = false 
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
