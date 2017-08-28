//
//  GameScene+Settings.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 03.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    struct BitMasks {
        static let spaceship: UInt32 = 0b1
        static let fireBall: UInt32 = 0b10
        static let enemy: UInt32 = 0b100
        static let whirl: UInt32 = 0b101
    }
    
    func startPosition(forNodeWithName name: String) -> CGPoint? {
        switch name {
        case "background": return self.size.center
        case "background2": return CGPoint(x: self.size.center.x, y: self.size.height * 1.5)
        case "backgroundEffect": return self.size.center
        case "scoreLabel" : return self.size.center
        case "enemy":
            let enemy = SKSpriteNode(imageNamed: "Raumschiff")
            return randomTopPosition(for: enemy)
        case "whirl":
            return randomTopPosition(for: Whirl())
        case "fireBall": return spaceship.position
        case "heart1":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 1 * heart.size.width, y: self.size.height - heart.size.height)
        case "heart2":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 2 * heart.size.width, y: self.size.height - heart.size.height)
        case "heart3":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 3 * heart.size.width, y: self.size.height - heart.size.height)
        case "spaceship": return CGPoint(x: self.size.center.x, y: self.size.height * 0.15)
        case "pauseBackground": return self.size.center
        case "pauseLabel": return self.size.center
        default: return nil
        }
    }
    
    private func randomTopPosition(for node: SKSpriteNode) -> CGPoint {
        let startX = CGFloat(arc4random_uniform(UInt32(self.size.width - 2 * node.size.width))) + node.size.width
        let startY = self.size.height + node.size.height
        return CGPoint(x: startX, y: startY)
    }
    
    func zPosition(forNodeWithName name: String) -> CGFloat? {
        switch name {
        case "background": return 0
        case "background2": return 0
        case "backgroundEffect": return 1
        case "scoreLabel" : return 1
        case "enemy": return 2
        case "whirl": return 2
        case "fireBall": return 2
        case "spaceship": return 3
        case "explosion": return 4
        case "heart1", "heart2", "heart3": return 5
        case "pauseBackground": return 30
        case "pauseLabel": return 31
        default: return nil
        }
    }
    
//    func physicsBody(forNodeWithName name: String) -> SKPhysicsBody? {
//        switch name {
//        case "spaceship":
//            return SKPhysicsBody(texture: spaceship.texture!, size: spaceship.size)
//        case "fireBall":
//            let fireBall = SKSpriteNode(imageNamed: "Sternschuss")
//            return SKPhysicsBody(circleOfRadius: fireBall.size.width / 2)
//        case "enemy":
//            let enemy = SKSpriteNode(imageNamed: "Raumschiff")
//            return SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
//        default: return nil
//        }
//    }
//
//    func isDynamic(forNodeWithName name: String) -> Bool? {
//        switch name {
//        case "spaceship": return false
//        case "fireBall": return false
//        case "enemy": return true
//        // case "heart1", "heart2", "heart3": return false
//        default: return nil
//        }
//    }
    
    class func categoryBitMask(forNodeWithName name: String) -> UInt32? {
        switch name {
        case "spaceship": return BitMasks.spaceship
        case "fireBall": return BitMasks.fireBall
        case "enemy": return BitMasks.enemy
        case "whirl": return BitMasks.whirl
        default: return nil
        }
    }
    
    func contactTestBitMask(forNodeWithName name: String) -> UInt32? {
        switch name {
        case "spaceship": return BitMasks.enemy | BitMasks.whirl
        case "fireBall": return BitMasks.enemy | BitMasks.whirl
        case "enemy": return BitMasks.spaceship | BitMasks.fireBall
        case "whirl": return BitMasks.spaceship | BitMasks.fireBall
        default: return nil
        }
    }
    
    func collisionBitMask(forNodeWithName name: String) -> UInt32? {
        switch name {
        case "spaceship": return BitMasks.whirl | BitMasks.enemy
        case "fireBall": return 0
        case "enemy": return BitMasks.spaceship
        case "whirl": return BitMasks.spaceship
        default: return nil
        }
    }
    
//    func physics(forNodeWithName name: String) -> SKPhysicsBody? {
//        guard let body = physicsBody(forNodeWithName: name)
//            else { return nil }
//        
//        if let isDynamic = isDynamic(forNodeWithName: name) {
//            body.isDynamic = isDynamic
//        }
//        if let categoryBitMask = GameScene.categoryBitMask(forNodeWithName: name) {
//            body.categoryBitMask = categoryBitMask
//        }
//        if let contactTestBitMask = contactTestBitMask(forNodeWithName: name) {
//            body.contactTestBitMask = contactTestBitMask
//        }
//        
//        return body
//    }
}
