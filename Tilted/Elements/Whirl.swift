//
//  Whirl.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 10.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class Whirl: SKSpriteNode, Sprite {
    var healthPoints = 5
    let textureAtlas = SKTextureAtlas(named: "Whirl")
    var shape: Shape = .folded
    
    enum Shape {
        case folded
        case changing
        case unfolded
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Whirl Folded")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size()) // circleOfRadius: size.width / 2)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        // Rotation
        let rotation = SKAction.rotate(byAngle: 360 * .pi / 180, duration: 1)
        run(SKAction.repeatForever(rotation))
        
        // Travel
        let xTravelDistance = size.width * 0.1
        let yTravelDistance = size.height * 0.5
        let xTiltCompensation = yTravelDistance / size.height * size.width
        let yTiltCompensation = xTravelDistance / size.width * size.height
        let moveDownAndRight = SKAction.moveBy(x:  xTravelDistance + xTiltCompensation, y: -(yTravelDistance + yTiltCompensation), duration: 0.4)
        let moveDownAndLeft = SKAction.moveBy(x: -xTravelDistance + xTiltCompensation, y: -(yTravelDistance + yTiltCompensation), duration: 0.4)
        let deleteWhenLeaving = SKAction.perform(#selector(deleteWhenLeavingScreen), onTarget: self)
        let wiggle = SKAction.sequence([moveDownAndLeft, moveDownAndRight, deleteWhenLeaving])
        run(SKAction.repeatForever(wiggle), withKey: "wiggle")
    }
    
    @objc func deleteWhenLeavingScreen() {
        if position.y < 0 - size.height / 2 {
            removeFromParent()
        }
    }
    
    func unfold() {
        shape = .changing
        
        // let textureAtlas = SKTextureAtlas(named: "Whirl")
        let frames = ["Whirl Folded", "Whirl Almost Folded", "Whirl Almost Unfolded", "Whirl Unfolded"].map { textureAtlas.textureNamed($0) }
        animate(with: frames, timePerFrame: 0.3)

        shape = .unfolded
    }
    
    func animate(with textures: [SKTexture], timePerFrame: TimeInterval) {
        let wait = SKAction.wait(forDuration: 1)
        let physics = SKAction.perform(#selector(setupPhysicsBody), onTarget: self)
        var actions = [SKAction]()
        
        for texture in textures {
            let action = SKAction.setTexture(texture, resize: true)
            actions.append(action)
            actions.append(physics)
            actions.append(wait)
        }
        
        run(SKAction.sequence(actions))
    }
    
    @objc func setupPhysicsBody() {
        guard let texture = self.texture
            else { return }
        let oldBody = physicsBody
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        if let oldBody = oldBody {
            physicsBody?.categoryBitMask = oldBody.categoryBitMask
            physicsBody?.contactTestBitMask = oldBody.contactTestBitMask
            physicsBody?.collisionBitMask = oldBody.collisionBitMask
        }
    }
    
//    func update(_ currentTime: TimeInterval) {
//        run(SKAction.rotate(byAngle: 5 * .pi / 180, duration: <#T##TimeInterval#>))
//    }
}
