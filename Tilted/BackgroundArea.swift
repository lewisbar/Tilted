//
//  BackgroundArea.swift
//  Tilted
//
//  Created by Lennart Wisbar on 15.08.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

struct BackgroundArea {
    var path: CGPath
    
    func contains(_ p: CGPoint) -> Bool {
        return path.contains(p)
    }
}
