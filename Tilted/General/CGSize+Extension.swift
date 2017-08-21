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
    
    // Returns the angle in radians that is above the diagonal that goes from the lower right to the upper left corner, so the direction of spaceship and enemies fits the screen dimensions.
    func lowerRightAngleAboveDiagonal() -> CGFloat {
        let a = width
        let b = height
        let c = sqrt(a * a + b * b)
        return asin(a / c)
    }
}
