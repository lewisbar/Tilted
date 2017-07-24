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
        spaceship.handleOffset = CGPoint(x: self.size.width * 0.1, y: -self.size.height * 0.1)
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
        return hypot(spaceship.handle.x - position.x,
                     spaceship.handle.y - position.y)
    }
    
    private func isOnBackground(_ location: CGPoint) -> Bool {
        return !(fireButton.contains(location))
            && !(pauseButton.contains(location))
            && atPoint(location) != pauseLayer
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if isOnBackground(location) {
                if fireButton.contains(touch.previousLocation(in: self)) {
                    spaceship.stopShooting()
                } else {
                    if var remainingTouches = event?.allTouches {
                        remainingTouches = remainingTouches.filter { $0.phase != .ended }
                        if let closestTouch = touchClosestToSpaceship(touches: event?.allTouches) {
                            spaceship.moveHandle(to: closestTouch.location(in: self))
                            return
                        }
                    }
                }
            }
        }
    }

    private func touchesSortedByDistanceToSpaceship(_ touches: Set<UITouch>?) -> [UITouch]? {
        if let touches = touches {
        return touches.sorted {
            distanceFromSpaceship(to: $0.location(in: self))
                < distanceFromSpaceship(to: $1.location(in: self))
            }
        }
        return nil
    }
    
    private func touchClosestToSpaceship(touches: Set<UITouch>?) -> UITouch? {
        if let touches = touches {
            let orderedTouches = touchesSortedByDistanceToSpaceship(touches)
            return orderedTouches?.first
        }
        return nil
    }
    
    // TODO: When two fingers touch the background and the spaceship finger is shortly lifted and then put down again before the spaceship is closer to the other finger, the spaceship first returns to the original spaceship finger and then travels to the other finger. I'm not sure if this bug is to be found in touchesBegan or touchesEnded, or both.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location) == pauseLayer {
                pauseLayerTouched = true
                isPaused = false
                return
            } else if pauseButton.contains(location) {
                isPaused = true
            }
            
            if fireButton.contains(location) {
                let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
                spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
            }
            
            if isOnBackground(location) {
                if var remainingTouches = event?.allTouches {
                    remainingTouches = remainingTouches.filter { $0.phase != .ended }
                    if let closestTouch = touchClosestToSpaceship(touches: remainingTouches) {
                        spaceship.moveHandle(to: closestTouch.location(in: self))
                        return
                    }
                }
            }
        }
    }
    
    fileprivate func fireButtonIsStillBeingTouched(event: UIEvent?, endedTouch: UITouch) -> Bool {
        if let allTouches = event?.allTouches {
            for otherTouch in allTouches {
                if otherTouch != endedTouch, fireButton.contains(otherTouch.location(in: self)) {
                    return true
                }
            }
        }
        return false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButton.contains(location) {
                if !fireButtonIsStillBeingTouched(event: event, endedTouch: touch) {
                    spaceship.stopShooting()
                }
            } else if isOnBackground(location) {
                // TODO: Spaceship sometimes moves to finger on fire button if it is the closest touch.
                // To reproduce:
                // - Hold spaceship near the fire button
                // - Put a second finger far away from the spaceship (at least farther than the fire button)
                // - Put a third finger on the fire button
                // - Release the spaceship finger
                // -> The spaceship now should move to the finger that is not on the fire button, but it first moves to the fire button and then to the correct finger
                if touch == touchClosestToSpaceship(touches: event?.allTouches),
                    var remainingTouches = event?.allTouches {
                    remainingTouches = remainingTouches.filter { isOnBackground($0.location(in: self)) && $0.phase != .ended }

                    if let nextClosestTouch = touchClosestToSpaceship(touches: remainingTouches) {
                        spaceship.moveHandle(to: nextClosestTouch.location(in: self))
                        //return
                    }
                }
            }
        }
    }
}
