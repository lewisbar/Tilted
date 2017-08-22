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
    var flyingSpeed: CGFloat = 10 {  // in spaceship lengths per second; 10-30 recommended
        didSet {
            exhaustFlame?.particleSpeed = flyingSpeed * speedToFlameLengthFactor
        }
    }
    let exhaustFlame = SKEmitterNode(fileNamed: "ExhaustFlame")
    let speedToFlameLengthFactor: CGFloat = 10
    var shootingTimer = Timer()
    var handleOffset = CGPoint(x: 0, y: 0)
    var handle: CGPoint {
        let x = self.position.x + handleOffset.x
        let y = self.position.y + handleOffset.y
        return CGPoint(x: x, y: y)
    }
    var flyingTarget: CGPoint?
    
    init() {
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        setupExhaustFlame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupExhaustFlame() {
        exhaustFlame?.position = CGPoint(x: 0, y: -self.size.height / 2)
        exhaustFlame?.zRotation = .pi
        exhaustFlame?.zPosition = -1
        exhaustFlame?.particleSpeed = flyingSpeed * speedToFlameLengthFactor
        self.addChild(exhaustFlame!)
    }
}

// MARK: - Movement
extension Spaceship {
    func updateMovement() {
        // TODO: Make the ship lean to the side to which it moves
        guard let target = flyingTarget else { return }
        let speed = flyingSpeed * size.height / 60
        let xDifference = abs(handle.x - target.x)
        let yDifference = abs(handle.y - target.y)
        let combinedDifference = xDifference + yDifference
        let xMovement = (speed / combinedDifference) * xDifference
        let yMovement = (speed / combinedDifference) * yDifference

        if target.x >= handle.x + xMovement {
            position.x += xMovement
        } else if target.x < handle.x - xMovement {
            position.x -= xMovement
        } else {
            position.x = target.x - handleOffset.x
        }

        if target.y >= handle.y + yMovement {
            position.y += yMovement
        } else if target.y < handle.y - yMovement {
            position.y -= yMovement
        } else {
            position.y = target.y - handleOffset.y
        }
    }
    
    func stopMoving() {
        flyingTarget = nil
    }
}

// MARK: - Shooting
extension Spaceship {
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
}
