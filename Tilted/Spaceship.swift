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
    var flyingTarget: CGPoint?
    let exhaustFlame = SKEmitterNode(fileNamed: "ExhaustFlame")
    var shootingTimer = Timer()
    var handleOffset = CGPoint(x: 0, y: 0)
    var handle: CGPoint {
        let x = self.position.x + handleOffset.x
        let y = self.position.y + handleOffset.y
        return CGPoint(x: x, y: y)
    }
    
    func updateMovement() {
        guard let target = flyingTarget else { return }
        
        //TODO: Change x and y so that the ship flies directly towards the goal. The dimension with bigger difference needs to change faster.
        // 10 ship lengths per second means 10/60 ship lengths per frame
        //let ratio = (target.x - handle.x) / (target.y - handle.y)
        //let distance = hypot(handle.x - target.x, handle.y - target.y)
        let speed = flyingSpeed * size.height / 60
        let xDifference = handle.x - target.x
        let yDifference = handle.y - target.y
        let combinedDifference = xDifference + yDifference
        
//        position.x += (speed / combinedDifference) * xDifference
//        position.y += (speed / combinedDifference) * yDifference
        
        if target.x >= handle.x + flyingSpeed {
            position.x += (speed / combinedDifference) * xDifference
        } else if target.x < handle.x - flyingSpeed {
            position.x -= (speed / combinedDifference) * xDifference
        } else {
            position.x = target.x - handleOffset.x
        }

        if target.y >= handle.y + flyingSpeed {
            position.y += (speed / combinedDifference) * yDifference
        } else if target.y < handle.y - flyingSpeed {
            position.y -= (speed / combinedDifference) * yDifference
        } else {
            position.y = target.y - handleOffset.y
        }
    }
    
    func moveHandle(to destination: CGPoint) {
        let spaceshipDestination = CGPoint(x: destination.x - handleOffset.x, y: destination.y - handleOffset.y)
        let distance = hypot(handle.x - destination.x, handle.y - destination.y)
        let duration = TimeInterval(distance / (flyingSpeed * size.height))
        let move = SKAction.move(to: spaceshipDestination, duration: duration)
        //removeAction(forKey: "move")
        run(move)//, withKey: "move")
    }
    
    func stopMoving() {
        flyingTarget = nil
        //removeAction(forKey: "move")
        //removeAllActions()
//        let stop = SKAction.move(to: position, duration: 0)
//        run(stop)
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
