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
    var flyingSpeed: CGFloat = 10   // in spaceship lengths per second
    let exhaustFlame = SKEmitterNode(fileNamed: "ExhaustFlame")
    var shootingTimer = Timer()
    var handleOffset = CGPoint(x: 0, y: 0)
    var handle: CGPoint {
        let x = self.position.x + handleOffset.x
        let y = self.position.y + handleOffset.y
        return CGPoint(x: x, y: y)
    }
    
    func moveHandle(to destination: CGPoint) {
        let spaceshipDestination = CGPoint(x: destination.x - handleOffset.x, y: destination.y - handleOffset.y)
        let distance = hypot(handle.x - destination.x, handle.y - destination.y)
        let duration = TimeInterval(distance / (flyingSpeed * size.height))
        let move = SKAction.move(to: spaceshipDestination, duration: duration)
        run(move)
    }
    
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
    
    func startShooting(with vector: CGVector, zPosition: CGFloat) {
        guard !shootingTimer.isValid else { return }
        
        // First shot
        self.shoot(with: vector, zPosition: zPosition)

        // Continuous fire
        shootingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.shoot(with: vector, zPosition: zPosition)
        }
    }
    
    func stopShooting() {
        shootingTimer.invalidate()
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
