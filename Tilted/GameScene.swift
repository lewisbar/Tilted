//
//  GameScene.swift
//  Tilted
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: Background
    let backgroundBottomRight = SKSpriteNode(imageNamed: "Background")
    let backgroundBottomLeft = SKSpriteNode(imageNamed: "Background")
    let backgroundTopRight = SKSpriteNode(imageNamed: "Background")
    let backgroundTopLeft = SKSpriteNode(imageNamed: "Background")
    
    enum BackgroundPosition {
        case bottomRight
        case bottomLeft
        case topRight
        case topLeft
    }
    
    func backgroundPosition(_ position: BackgroundPosition) -> CGPoint {
        switch position {
        case .bottomRight: return .zero
        case .bottomLeft: return CGPoint(x: -self.size.width, y: 0)
        case .topRight: return CGPoint(x: 0, y: self.size.height)
        case .topLeft: return CGPoint(x: -self.size.width, y: self.size.height)
        }
    }
    
    func setupBackgrounds() {
        let backgrounds = [backgroundBottomRight, backgroundBottomLeft, backgroundTopRight, backgroundTopLeft]
        for background in backgrounds {
            background.size = self.size
            background.anchorPoint = .zero
        }
        
        backgroundBottomRight.position = backgroundPosition(.bottomRight)
        backgroundBottomLeft.position = backgroundPosition(.bottomLeft)
        backgroundTopRight.position = backgroundPosition(.topRight)
        backgroundTopLeft.position = backgroundPosition(.topLeft)
        
        for background in backgrounds { self.addChild(background) }
        
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
    
    override func didMove(to view: SKView) {
        setupBackgrounds()
    }
}
