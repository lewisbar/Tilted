//
//  GameScene.swift
//  Tilted
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var backgrounds: [SKSpriteNode]!
    let spaceship = Spaceship()
    var fireButton: CornerButton!
    var pauseButton: CornerButton!
    var pauseLayer: SKShapeNode?
    var pauseLayerTouched = false
    let spaceshipSpeed: CGFloat = 1
    //var backgroundIsBeingTouched = false
    
    override var isPaused: Bool {
        didSet {
            if isPaused == false {
                guard pauseLayer != nil else { return }
                if !(pauseLayer?.isHidden)! {
                    guard pauseLayerTouched else {
                        isPaused = true
                        return
                    }
                    pauseLayer?.isHidden = true
                    pauseLayerTouched = false
                }
            } else if isPaused == true {
                pauseLayer?.isHidden = false
            }
        }
    }
    
    struct ZPositions {
        static let background: CGFloat = 0
        static let shot: CGFloat = 1
        static let spaceship: CGFloat = 2
        static let buttons: CGFloat = 3
        static let pauseLayer: CGFloat = 4
    }
    
    func setupBackground() {
        backgrounds = MovingBackground.setup(in: self)
        for background in backgrounds {
            background.zPosition = ZPositions.background
        }
    }
    
    func setupSpaceship() {
        spaceship.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.3)
        spaceship.zRotation = self.size.lowerRightAngleOverDiagonal()
        spaceship.zPosition = ZPositions.spaceship
        self.addChild(spaceship)
    }
    
    func setupFireButton() {
        let buttonSize = CGSize(width: size.width / 4, height: size.height / 4)
        fireButton = CornerButton(size: buttonSize, corner: .bottomLeft, in: self)
        fireButton.zPosition = ZPositions.buttons
        addChild(fireButton)
    }
    
    func setupPauseButton() {
        let buttonSize = CGSize(width: size.width / 4, height: size.height / 4)
        pauseButton = CornerButton(size: buttonSize, corner: .topRight, in: self)
        pauseButton.zPosition = ZPositions.buttons
        addChild(pauseButton)
    }
    
    func setupPauseLayer() {
        pauseLayer = SKShapeNode(rectOf: size)
        pauseLayer?.fillColor = SKColor.lemonYellow.withAlphaComponent(0.3)
        pauseLayer?.position = size.center
        pauseLayer?.zPosition = ZPositions.pauseLayer
        pauseLayer?.isHidden = true
        addChild(pauseLayer!)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        setupBackground()
        setupFireButton()
        setupPauseButton()
        setupPauseLayer()
        setupSpaceship()
    }
    
    func distanceFromSpaceship(to position: CGPoint) -> CGFloat {
        return hypot(spaceship.position.x - position.x, spaceship.position.y - position.y)
    }
    
    func moveSpaceship(to location: CGPoint) {
        let destination = CGPoint(x: location.x - self.size.width * 0.1, y: location.y + self.size.height * 0.1)
        let distance = distanceFromSpaceship(to: destination)
        let duration = TimeInterval(distance * spaceshipSpeed / 1000)
        let move = SKAction.move(to: destination, duration: duration)
        spaceship.run(move)
    }
    
    private func isOnBackground(_ location: CGPoint) -> Bool {
        return !(fireButton.path!.contains(location))
            && !(pauseButton.path!.contains(location))
            && atPoint(location) != pauseLayer
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if isOnBackground(location) {
                if fireButton.path!.contains(touch.previousLocation(in: self)) {
                    spaceship.stopShooting()
                } else {
                    moveSpaceship(to: location)
                }
            }
        }
//        // Only the closest touch should move the spaceship
//        let orderedTouches = touches.sorted {
//            distanceFromSpaceship(to: $0.location(in: self))
//                < distanceFromSpaceship(to: $1.location(in: self))
//        }
//        for touch in orderedTouches {
//            let location = touch.location(in: self)
//            if isOnBackground(location) {
//                moveSpaceship(to: location)
//                return
//            }
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location) == pauseLayer {
                pauseLayerTouched = true
                isPaused = false
                return
            } else if pauseButton.path!.contains(location) {
                isPaused = true
            }
            
            if fireButton.path!.contains(location) {
                let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
                spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
            }
            
            if isOnBackground(location) {
                moveSpaceship(to: location)
            }
//            if isOnBackground(location), !backgroundIsBeingTouched {
//                backgroundIsBeingTouched = true
//                moveSpaceship(to: location)
//            } else if isOnBackground(touch.previousLocation(in: self)) {
//                backgroundIsBeingTouched = false
//            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButton.path!.contains(location) {
                spaceship.stopShooting()
            } /*else if isOnBackground(location) {
                backgroundIsBeingTouched = false
            }*/
        }
    }
}
