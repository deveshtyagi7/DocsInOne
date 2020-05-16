//
//  Shaddow.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 14/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import Foundation
import UIKit

class Shadow {
    
    public static func applyShadowOnView(yourView : UIView , radius : CGFloat){
        yourView.layer.cornerRadius = radius
        yourView.layer.shadowColor = UIColor.black.cgColor
        yourView.layer.shadowOpacity = 0.2
        yourView.layer.shadowOffset = .zero
        yourView.layer.shadowRadius = 15
        
        yourView.layer.shadowPath = UIBezierPath(rect: yourView.bounds).cgPath
        
        yourView.layer.shouldRasterize = true
        yourView.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
