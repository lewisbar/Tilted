//
//  CornerButton.swift
//  Tilted
//
//  Created by Lennart Wisbar on 17.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class CornerButton: SKShapeNode {
    
    //var size: CGSize!
    
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    init(size: CGSize, corner: Corner, in scene: SKScene) {
        super.init()
        //self.size = size
        
        let trianglePath = UIBezierPath()
        
        switch corner {
        case .topLeft:
            trianglePath.move(to: CGPoint(x: 0, y: scene.size.height))
            trianglePath.addLine(to: CGPoint(x: 0, y: scene.size.height - size.height))
            trianglePath.addLine(to: CGPoint(x: size.width, y: scene.size.height))
            trianglePath.close()
        case .topRight:
            trianglePath.move(to: CGPoint(x: scene.size.width, y: scene.size.height))
            trianglePath.addLine(to: CGPoint(x: scene.size.width, y: scene.size.height - size.height))
            trianglePath.addLine(to: CGPoint(x: scene.size.width - size.width, y: scene.size.height))
            trianglePath.close()
        case .bottomLeft:
            trianglePath.move(to: CGPoint(x: 0, y: 0))
            trianglePath.addLine(to: CGPoint(x: 0, y: size.height))
            trianglePath.addLine(to: CGPoint(x: size.width, y: 0))
            trianglePath.close()
        case .bottomRight:
            trianglePath.move(to: CGPoint(x: scene.size.width, y: 0))
            trianglePath.addLine(to: CGPoint(x: scene.size.width, y: size.height))
            trianglePath.addLine(to: CGPoint(x: scene.size.width - size.width, y: 0))
            trianglePath.close()
        }
        
        fillColor = UIColor.treePoppy
        trianglePath.fill()

        path = trianglePath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
