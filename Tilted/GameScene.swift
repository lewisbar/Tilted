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
//        return hypot((spaceship.position.x + self.size.width * 0.1) - position.x,
//                     (spaceship.position.y - self.size.height * 0.1) - position.y)
    }
    
//    func moveSpaceship(to location: CGPoint) {
//        let destination = CGPoint(x: location.x - self.size.width * 0.1, y: location.y + self.size.height * 0.1)
//        let distance = distanceFromSpaceship(to: destination)
//        let duration = TimeInterval(distance * spaceship.flyingSpeed / 1000)
//        let move = SKAction.move(to: destination, duration: duration)
//        spaceship.run(move)
//    }
    
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
                    
                    if let closestTouch = touchClosestToSpaceship(touches: event?.allTouches) {
                        spaceship.moveHandle(to: closestTouch.location(in: self))
                        return
                    }
                    //spaceship.moveHandle(to: location)
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
//                spaceship.moveHandle(to: location)
//                return
//            }
//        }
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
                if let closestTouch = touchClosestToSpaceship(touches: event?.allTouches) {
                    spaceship.moveHandle(to: closestTouch.location(in: self))
                    return
                }
            }
        }
    }
    
    fileprivate func fireButtonIsStillBeingTouched(_ event: UIEvent?, _ touch: UITouch) -> Bool {
        if let allTouches = event?.allTouches {
            for otherTouch in allTouches {
                if otherTouch != touch, fireButton.path!.contains(otherTouch.location(in: self)) {
                    return true
                }
            }
        }
        return false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButton.path!.contains(location) {
                if !fireButtonIsStillBeingTouched(event, touch) {
                    spaceship.stopShooting()
                }
            } else if isOnBackground(location) {
                if touch == touchClosestToSpaceship(touches: event?.allTouches),
                    var remainingTouches = event?.allTouches {
                    remainingTouches.remove(touch)
                    for remainingTouch in remainingTouches {
                        let loc = remainingTouch.location(in: self)
                        if !isOnBackground(loc) {
                            remainingTouches.remove(remainingTouch)
                        }
                    }
                    if let nextClosestTouch = touchClosestToSpaceship(touches: remainingTouches) {
                        spaceship.moveHandle(to: nextClosestTouch.location(in: self))
                        return
                    }
                }
            }
        }
    }
}
