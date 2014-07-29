//
//  SwiftButton.swift
//  OverrideProperty1
//
//  Created by Tatiana Kornilova on 6/22/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

class SwiftButton: UIButton {
   
    init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }
    
    override var highlighted:Bool {
    set {
        println("Overriden")
        super.highlighted = newValue
    }
    get{
        return super.highlighted
    }
    }
    
}
