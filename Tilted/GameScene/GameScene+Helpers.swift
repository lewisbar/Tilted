//
//  GameScene+Helpers.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 03.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import AVFoundation

extension GameScene {
    func setupNode(_ node: SKNode, name: String) {
        node.name = name
        if let position = startPosition(forNodeWithName: name) {
            node.position = position
        }
        if let zPosition = zPosition(forNodeWithName: name) {
            node.zPosition = zPosition
        }
        
        guard let spriteNode = node as? SKSpriteNode else { return }
        
//        if let physicsBody = physicsBody(forNodeWithName: name) {
//            spriteNode.physicsBody = physicsBody
//        }
//        if let isDynamic = isDynamic(forNodeWithName: name) {
//            spriteNode.physicsBody?.isDynamic = isDynamic
//        }
        if let categoryBitMask = GameScene.categoryBitMask(forNodeWithName: name) {
            spriteNode.physicsBody?.categoryBitMask = categoryBitMask
        }
        if let contactTestBitMask = contactTestBitMask(forNodeWithName: name) {
            spriteNode.physicsBody?.contactTestBitMask = contactTestBitMask
        }
        if let collisionBitMask = collisionBitMask(forNodeWithName: name) {
            spriteNode.physicsBody?.collisionBitMask = collisionBitMask
        }
    }
    
    @objc func addEnemy() {
        let enemy = Enemy() // SKSpriteNode(imageNamed: "Raumschiff")
        setupNode(enemy, name: "enemy")
        enemy.zRotation = .pi   // Upside down
        self.addChild(enemy)
        
        // Action
        let moveDown = SKAction.moveTo(y: -enemy.size.height, duration: 3)
        let delete = SKAction.removeFromParent()
        
        enemy.run(SKAction.sequence([moveDown, delete]))
    }
    
    @objc func addWhirl() {
        let whirl = Whirl()
        setupNode(whirl, name: "whirl")
        self.addChild(whirl)
        whirl.startMoving()
    }
    
    @objc func shootFireBall() {
        let fireBall = FireBall() // SKSpriteNode(imageNamed: "Sternschuss")
        setupNode(fireBall, name: "fireBall")
        self.addChild(fireBall)
        
        // Action
        let aim = CGPoint(x: fireBall.position.x ,y: self.size.height + fireBall.size.height)
        fireBall.shoot(at: aim)
    }
    
    func addHealthPoints(_ health: Int) {
        for index in 1...health {
            let heart = SKSpriteNode(imageNamed: "Herz")
            setupNode(heart, name: "heart\(index)")
            lifeArray.append(heart)
            self.addChild(heart)
        }
    }
    
    func prepareMusic() {
        guard let musicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
        } catch {
            print("Music player can't be initialized")
        }
        musicPlayer?.numberOfLoops = -1
        musicPlayer?.prepareToPlay()
    }
    
    //    func fireBall(_ fireBall: SKSpriteNode, hits enemy: SKSpriteNode) {
    //        fireBall.removeFromParent()
    //        enemy.removeFromParent()
    //        score += 1
    //    }
}
