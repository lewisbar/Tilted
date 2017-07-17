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
    var fireButton: FireButton!
    var pauseButton: PauseButton!
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
        spaceship.zRotation = self.size.lowerRightAngleOverDiagonal()
        spaceship.zPosition = ZPositions.spaceship
        self.addChild(spaceship)
    }
    
    func setupFireButton() {
        fireButton = FireButton(size: CGSize(width: size.width / 4, height: size.height / 4))
        fireButton.position = .zero
        fireButton.zPosition = ZPositions.buttons
        addChild(fireButton)
    }
    
    func setupPauseButton() {
        pauseButton = PauseButton(size: CGSize(width: size.width / 4, height: size.height / 4))
        pauseButton.position = size.topRight
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
    
    // TODO: Path recognition for pause button doesn't work
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if !(fireButton.path!.contains(location)),
                atPoint(location) != pauseButton, //!(pauseButton.path!.contains(location)),
                atPoint(location) != pauseLayer {

                let destination = CGPoint(x: location.x - self.size.width * 0.1, y: location.y + self.size.height * 0.1)
                let distance = hypot(spaceship.position.x - destination.x, spaceship.position.y - destination.y)
                let duration = TimeInterval(distance / 1000)
                let move = SKAction.move(to: destination, duration: duration)
                spaceship.run(move)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButton.path!.contains(location) {
                let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
                spaceship.shoot(with: shootingVector, zPosition: ZPositions.shot)
            } else if atPoint(location) == pauseButton{//pauseButton.path!.contains(location) {
                isPaused = true
            } else if atPoint(location) == pauseLayer {
                pauseLayerTouched = true
                isPaused = false
            }
        }
    }
}
