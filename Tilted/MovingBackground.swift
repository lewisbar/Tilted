//
//  Background.swift
//  Tilted
//
//  Created by Lennart Wisbar on 15.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

struct MovingBackground {
    static func setup(in scene: SKScene) {
        let backgroundBottomRight = SKSpriteNode(imageNamed: "Background")
        let backgroundBottomLeft = SKSpriteNode(imageNamed: "Background")
        let backgroundTopRight = SKSpriteNode(imageNamed: "Background")
        let backgroundTopLeft = SKSpriteNode(imageNamed: "Background")
        
        let backgrounds = [backgroundBottomRight, backgroundBottomLeft, backgroundTopRight, backgroundTopLeft]
        
        for background in backgrounds {
            background.size = scene.size
            background.anchorPoint = .zero
        }
        
        backgroundBottomRight.position = .zero
        backgroundBottomLeft.position = CGPoint(x: -scene.size.width, y: 0)
        backgroundTopRight.position = CGPoint(x: 0, y: scene.size.height)
        backgroundTopLeft.position = CGPoint(x: -scene.size.width, y: scene.size.height)
        
        for background in backgrounds { scene.addChild(background) }
        
        for background in backgrounds {
            let destination = CGPoint(x: background.position.x + background.size.width, y: background.position.y - background.size.height)
            let moveToOwnBottomRight = SKAction.move(to: destination, duration: 3)
            
            let originalPosition = background.position
            let jumpBackToStart = SKAction.move(to: originalPosition, duration: 0)
            
            let moveSequence = SKAction.sequence([moveToOwnBottomRight, jumpBackToStart])
            let moveCycle = SKAction.repeatForever(moveSequence)
            
            background.run(moveCycle)
        }
    }
}
