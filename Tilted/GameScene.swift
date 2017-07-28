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
}

// MARK: - Setup
extension GameScene {
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
}

// MARK: - Moving the Spaceship
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        spaceship.updateMovement()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveSpaceshipToClosestTouch(event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveSpaceshipToClosestTouch(event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveSpaceshipToClosestTouch(event: event)
    }
    
    // Helpers
    private func moveSpaceshipToClosestTouch(event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        let remainingBackgroundTouches = allTouches.filter { $0.phase != .ended && isOnBackground($0.location(in: self)) }
        let positions = remainingBackgroundTouches.map { $0.location(in: self)}
        spaceship.flyingTarget = closestPositionToSpaceship(of: positions)
    }
    
    private func isOnBackground(_ location: CGPoint) -> Bool {
        return !(fireButton.contains(location))
            && !(pauseButton.contains(location))
            && atPoint(location) != pauseLayer
    }
    
    private func closestPositionToSpaceship(of positions: [CGPoint]) -> CGPoint? {
        let sortedPositions = positions.sorted { distanceFromSpaceship(to: $0) < distanceFromSpaceship(to: $1) }
        return sortedPositions.first
    }
    
    private func distanceFromSpaceship(to position: CGPoint) -> CGFloat {
        return hypot(spaceship.handle.x - position.x,
                     spaceship.handle.y - position.y)
    }
}

// MARK: - Corner Button Delegate
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

// MARK: - Pause Layer Delegate
extension GameScene: PauseLayerDelegate {
    func pauseLayerTouched(_ sender: PauseLayer) {
        pauseLayerTouched = true
        isPaused = false
    }
}


