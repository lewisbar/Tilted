//
//  CGSize+Extension.swift
//  Tilted
//
//  Created by Lennart Wisbar on 14.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

extension CGSize {
    
    var center: CGPoint {
        return CGPoint(x: self.width / 2, y: self.height / 2)
    }
    
    var topLeft: CGPoint {
        return CGPoint(x: 0, y: self.height)
    }
    
    var topRight: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
    
    var bottomLeft: CGPoint {
        return .zero
    }
    
    var bottomRight: CGPoint {
        return CGPoint(x: self.width, y: 0)
    }
    
    // Returns radians
    func lowerRightAngleOverDiagonal() -> CGFloat {
        let a = width
        let b = height
        let c = sqrt(a * a + b * b)
        return asin(a / c)
    }
}
