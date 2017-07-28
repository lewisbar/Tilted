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
    var pauseLayer: PauseLayer?
    var pauseLayerTouched = false
    lazy var buttonSize: CGSize = CGSize(width: size.width / 4, height: size.height / 4)
    
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
        static let navigationSpace: CGFloat = 3
        static let pauseLayer: CGFloat = 4
    }
    
    // MARK: - Setup
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
        fireButton = CornerButton(size: buttonSize, corner: .bottomLeft, in: self)
        fireButton.zPosition = ZPositions.buttons
        fireButton.delegate = self
        addChild(fireButton)
    }
    
    func setupPauseButton() {
        pauseButton = CornerButton(size: buttonSize, corner: .topRight, in: self)
        pauseButton.zPosition = ZPositions.buttons
        pauseButton.delegate = self
        addChild(pauseButton)
    }
    
    func setupPauseLayer() {
        pauseLayer = PauseLayer(rectOf: size)
        pauseLayer?.position = size.center
        pauseLayer?.zPosition = ZPositions.pauseLayer
        addChild(pauseLayer!)
        pauseLayer?.delegate = self
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        setupBackground()
        setupFireButton()
        setupPauseButton()
        setupPauseLayer()
        setupSpaceship()
    }
    
    override func update(_ currentTime: TimeInterval) {
        spaceship.updateMovement()
    }

    // MARK: - Touch Helpers
//    private func moveSpaceshipToClosestRemainingTouch(of touches: Set<UITouch>?) {
//        guard let touches = remainingBackgroundTouches(in: touches),
//            let nextClosestTouch = touchClosestToSpaceship(of: touches) else { return }
//        spaceship.moveHandle(to: nextClosestTouch.location(in: self))
//    }
    

}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let closestTouch = touchClosestToSpaceship(of: event?.allTouches) else { return }
        spaceship.flyingTarget = closestTouch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let closestTouch = touchClosestToSpaceship(of: event?.allTouches) else { return }
        spaceship.flyingTarget = closestTouch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let remainingTouches = remainingBackgroundTouches(in: event?.allTouches),
            !remainingTouches.isEmpty,
            let closestTouch = touchClosestToSpaceship(of: remainingTouches) {
            spaceship.flyingTarget = closestTouch.location(in: self)
        } else {
            spaceship.stopMoving()
        }
    }
    
    private func isOnBackground(_ location: CGPoint) -> Bool {
        return !(fireButton.contains(location))
            && !(pauseButton.contains(location))
            && atPoint(location) != pauseLayer
    }
    
    private func remainingBackgroundTouches(in touches: Set<UITouch>?) -> Set<UITouch>? {
        guard let remainingTouches = touches else { return nil }
        return remainingTouches.filter { isOnBackground($0.location(in: self)) && $0.phase != .ended }
    }
    
    private func touchClosestToSpaceship(of touches: Set<UITouch>?) -> UITouch? {
        return touchesSortedByDistanceToSpaceship(touches)?.first ?? nil
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
    
//    private func closestPositionToSpaceship(of positions: [CGPoint]) -> CGPoint? {
//        guard var closestPosition = positions.first else { return nil }
//        for position in positions {
//            if distanceFromSpaceship(to: position) < distanceFromSpaceship(to: closestPosition) {
//                closestPosition = position
//            }
//        }
//        return closestPosition
//    }
    
    private func distanceFromSpaceship(to position: CGPoint) -> CGFloat {
        return hypot(spaceship.handle.x - position.x,
                     spaceship.handle.y - position.y)
    }
}

extension GameScene: CornerButtonDelegate {
    func cornerButtonPressed(_ sender: CornerButton) {
        switch sender {
        case fireButton:
            let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
            spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
        case pauseButton:
            isPaused = true
        default:
            return
        }
    }
    
    func cornerButtonReleased(_ sender: CornerButton) {
        switch sender {
        case fireButton:
            spaceship.stopShooting()
        default:
            return
        }
    }
}

extension GameScene: PauseLayerDelegate {
    func pauseLayerTouched(_ sender: PauseLayer) {
        pauseLayerTouched = true
        isPaused = false
    }
}


