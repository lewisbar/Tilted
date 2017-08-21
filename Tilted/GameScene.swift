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
    var backgroundArea: BackgroundArea!
    let spaceship = Spaceship()
    var pauseLayer: PauseLayer?
    var pauseLayerTouched = false
    lazy var buttonSize = CGSize(width: size.width / 4, height: size.height / 4)
    
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
    func setupMovingBackground() {
        backgrounds = MovingBackground.setup(in: self)
        for background in backgrounds {
            background.zPosition = ZPositions.background
        }
    }
    
    func setupSpaceship() {
        spaceship.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.3)
        spaceship.handleOffset = CGPoint(x: self.size.width * 0.1, y: -self.size.height * 0.1)
        spaceship.zRotation = self.size.lowerRightAngleAboveDiagonal()
        spaceship.zPosition = ZPositions.spaceship
        self.addChild(spaceship)
    }
    
    func setupFireButton() {
        let fireButton = SKShapeNode(path: fireButtonPath)
        fireButton.zPosition = ZPositions.buttons
        addChild(fireButton)
    }
    
    func setupPauseButton() {
        let pauseButton = SKShapeNode(path: pauseButtonPath)
        pauseButton.zPosition = ZPositions.buttons
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
        setupMovingBackground()
        // setupBackgroundArea()
        setupFireButton()
        setupPauseButton()
        setupPauseLayer()
        setupSpaceship()
    }
}

// MARK: - Pause Layer Delegate
extension GameScene: PauseLayerDelegate {
    func pauseLayerTouched(_ sender: PauseLayer) {
        pauseLayerTouched = true
        isPaused = false
    }
}


