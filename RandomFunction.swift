//
//  RandomFunction.swift
//  DrizzyBird
//
//  Created by Omar Elnagdy on 3/25/17.
//  Copyright © 2017 Omar Elnagdy. All rights reserved.
//

import Foundation
import CoreGraphics 

public extension CGFloat{
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }



}
