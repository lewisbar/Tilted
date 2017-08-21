//
//  Paths.swift
//  Tilted
//
//  Created by Lennart Wisbar on 20.08.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

extension GameScene {
    var fireButtonPath: CGPath {
        let path = CGMutablePath()
        let c = size.bottomLeft
        let points = [
            c,
            CGPoint(x: c.x + buttonSize.width, y: c.y),
            CGPoint(x: c.x, y: c.y + buttonSize.height)
        ]
        path.addLines(between: points)
        return path
    }
    
    var pauseButtonPath: CGPath {
        let path = CGMutablePath()
        let c = size.topRight
        let points = [
            c,
            CGPoint(x: c.x, y: c.y - buttonSize.height),
            CGPoint(x: c.x - buttonSize.width, y: c.y)
        ]
        path.addLines(between: points)
        return path
    }
    
    var backgroundPath: CGPath {
        let path = CGMutablePath()
        let points = [
            CGPoint(x: buttonSize.width, y: 0),
            CGPoint(x: size.width, y: 0),
            CGPoint(x: size.width, y: size.height - buttonSize.height),
            CGPoint(x: size.width - buttonSize.width, y: size.height),
            CGPoint(x: 0, y: size.height),
            CGPoint(x: 0, y: buttonSize.height),
            CGPoint(x: buttonSize.width, y: 0)
        ]
        path.addLines(between: points)
        return path
    }
}
