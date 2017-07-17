//
//  Spaceship.swift
//  Tilted
//
//  Created by Lennart Wisbar on 15.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode, Sprite {
    
    var healthPoints = 3
    let exhaustFlame = SKEmitterNode(fileNamed: "ExhaustFlame")
    let endlessShootingKey = "endlessShootingSequence"
    //var shootingTimer = Timer()
    var isShooting = false
    
    @objc func shoot(with vector: CGVector, zPosition: CGFloat) {
        
        // Position in the spaceship's own coordinate system
        let shot = SKEmitterNode(fileNamed: "Shot")!
        shot.position = CGPoint(x: 0, y: size.height / 2)
        addChild(shot)
        
        // Add to parent
        shot.move(toParent: parent!)
        shot.zPosition = zPosition
        
        // Action
        let shoot = SKAction.move(by: vector, duration: 1)
        let delete = SKAction.removeFromParent()
        let shootingSequence = SKAction.sequence([shoot, delete])
        shot.run(shootingSequence)
    }
    
//    @objc func shot(with vector: CGVector, zPosition: CGFloat) -> SKAction {
//
//        // Position in the spaceship's own coordinate system
//        let shot = SKEmitterNode(fileNamed: "Shot")!
//        shot.position = CGPoint(x: 0, y: size.height / 2)
//        addChild(shot)
//
//        // Add to parent
//        shot.move(toParent: parent!)
//        shot.zPosition = zPosition
//
//        // Action
//        let shoot = SKAction.move(by: vector, duration: 1)
//        let delete = SKAction.removeFromParent()
//        return SKAction.sequence([shoot, delete])
//    }
    
    func startShooting(with vector: CGVector, zPosition: CGFloat) {
        // Position in the spaceship's own coordinate system
        let shot = SKEmitterNode(fileNamed: "Shot")!
        shot.position = CGPoint(x: 0, y: size.height / 2)
        addChild(shot)
        
        // Add to parent
        shot.move(toParent: parent!)
        shot.zPosition = zPosition
        
        // Action
        let shoot = SKAction.move(by: vector, duration: 1)
        let delete = SKAction.removeFromParent()
        let shootingSequence = SKAction.sequence([shoot, delete])
        let endlessShootingSequence = SKAction.repeatForever(shootingSequence)
        shot.run(endlessShootingSequence, withKey: endlessShootingKey)
//        while isShooting == true {
//            shoot(with: vector, zPosition: zPosition)
//        }
        //shootingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
//        let shoot = SKAction.perform(#selector(self.shoot), onTarget: self)
//        let wait = SKAction.wait(forDuration: 0.5)
//        let shootingSequence = SKAction.sequence([shoot, wait])
//        let endlessShootingSequence = SKAction.repeatForever(shootingSequence)
//        run(endlessShootingSequence, withKey: endlessShootingKey)
    }
    
    func stopShooting() {
        isShooting = false
        //shootingTimer.invalidate()
        //removeAction(forKey: endlessShootingKey)
    }
    
    func setupExhaustFlame() {
        exhaustFlame?.position = CGPoint(x: 0, y: -self.size.height / 2)
        exhaustFlame?.zRotation = .pi
        exhaustFlame?.zPosition = -1
        self.addChild(exhaustFlame!)
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        setupExhaustFlame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
