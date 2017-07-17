//
//  PauseButton.swift
//  Tilted
//
//  Created by Lennart Wisbar on 17.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class PauseButton: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        
        let trianglePath = UIBezierPath()
        
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: -size.height))
        trianglePath.addLine(to: CGPoint(x: -size.width, y: 0))
        trianglePath.close()
        
        fillColor = UIColor.treePoppy
        trianglePath.fill()
        
        path = trianglePath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
