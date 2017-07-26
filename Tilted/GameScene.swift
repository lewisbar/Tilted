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
    var navigationSpace: NavigationSpace!
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
    
//    func setupNavigationSpace() {
//        navigationSpace = NavigationSpace(cornerSize: buttonSize, in: self)
//        navigationSpace.zPosition = ZPositions.navigationSpace
//        navigationSpace.delegate = self
//        addChild(navigationSpace)
//    }
    
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
        //setupNavigationSpace()
        setupPauseLayer()
        setupSpaceship()
    }
    
    // MARK: - Touch Events
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            if fireButton.contains(location) {
//                startShooting()
//            } else if pauseButton.contains(location) {
//                isPaused = true
//            } else if isOnBackground(location), fireButton.contains(touch.previousLocation(in: self)), fireButtonIsStillBeingTouched(touches: event?.allTouches) {
//                spaceship.stopShooting()
//            } else if isOnBackground(location) {
//                moveSpaceshipToClosestRemainingTouch(touches: event?.allTouches)
//            }
//        }
//    }
//
//    // TODO: When two fingers touch the background and the spaceship finger is shortly lifted and then put down again before the spaceship is closer to the other finger, the spaceship first returns to the original spaceship finger and then travels to the other finger. I'm not sure if this bug is to be found in touchesBegan or touchesEnded, or both.
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//
//            if atPoint(location) == pauseLayer {
//                pauseLayerTouched = true
//                isPaused = false
//                return
//            } else if pauseButton.contains(location) {
//                isPaused = true
//            }
//
//            if fireButton.contains(location) {
//                startShooting()
//            }
//
//            if isOnBackground(location) {
//                moveSpaceshipToClosestRemainingTouch(touches: event?.allTouches)
//            }
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            if fireButton.contains(location), !fireButtonIsStillBeingTouched(touches: event?.allTouches) {
//                spaceship.stopShooting()
//            } else if isOnBackground(location) {
//                // TODO: Spaceship sometimes moves to finger on fire button if it is the closest touch.
//                // To reproduce:
//                // - Hold spaceship near the fire button
//                // - Put a second finger far away from the spaceship (at least farther than the fire button)
//                // - Put a third finger on the fire button
//                // - Release the spaceship finger
//                // -> The spaceship now should move to the finger that is not on the fire button, but it first moves to the fire button and then to the correct finger
//
//                moveSpaceshipToClosestRemainingTouch(touches: event?.allTouches)
//            }
//        }
//    }

    // MARK: - Touch Helpers
//    private func moveSpaceshipToClosestRemainingTouch(touches: Set<UITouch>?) {
//        guard let touches = remainingBackgroundTouches(in: touches),
//            let nextClosestTouch = touchClosestToSpaceship(touches: touches) else { return }
//        spaceship.moveHandle(to: nextClosestTouch.location(in: self))
//    }
    
//    private func startShooting() {
//        let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
//        spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
//    }
//
//    private func touchesSortedByDistanceToSpaceship(_ touches: Set<UITouch>?) -> [UITouch]? {
//        if let touches = touches {
//            return touches.sorted {
//                distanceFromSpaceship(to: $0.location(in: self))
//                    < distanceFromSpaceship(to: $1.location(in: self))
//            }
//        }
//        return nil
//    }
//    
//    private func isOnBackground(_ location: CGPoint) -> Bool {
//        return !(fireButton.contains(location))
//            && !(pauseButton.contains(location))
//            && atPoint(location) != pauseLayer
//    }
//    
//    private func remainingBackgroundTouches(in touches: Set<UITouch>?) -> Set<UITouch>? {
//        guard let remainingTouches = touches else { return nil }
//        return remainingTouches.filter { isOnBackground($0.location(in: self)) && $0.phase != .ended }
//    }
    
//    private func fireButtonIsStillBeingTouched(touches: Set<UITouch>?) -> Bool {
//        guard let touches = touches else { return false }
//        for touch in touches {
//            if fireButton.contains(touch.location(in: self)) {
//                return true
//            }
//        }
//        return false
//    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let positions = touches.map { $0.location(in: self) }
        guard let closestPosition = closestPositionToSpaceship(of: positions) else { return }
        spaceship.moveHandle(to: closestPosition)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let positions = touches.map { $0.location(in: self) }
        guard let closestPosition = closestPositionToSpaceship(of: positions) else { return }
        spaceship.moveHandle(to: closestPosition)
    }
    
    private func isOnBackground(_ location: CGPoint) -> Bool {
        return !(fireButton.contains(location))
            && !(pauseButton.contains(location))
            && atPoint(location) != pauseLayer
    }
    
    private func closestPositionToSpaceship(of positions: [CGPoint]) -> CGPoint? {
        guard var closestPosition = positions.first else { return nil }
        for position in positions {
            if distanceFromSpaceship(to: position) < distanceFromSpaceship(to: closestPosition) {
                closestPosition = position
            }
        }
        return closestPosition
    }
    
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

//extension GameScene: NavigationSpaceDelegate {
//    func navigationTouches(at positions: [CGPoint], in sender: NavigationSpace) {
//        guard let closestPosition = closestPositionToSpaceship(of: positions) else { return }
//        spaceship.moveHandle(to: closestPosition)
//    }
//
//    func navigationTouchesEnded() {
//        spaceship.stopMoving()
//    }
//
//    private func closestPositionToSpaceship(of positions: [CGPoint]) -> CGPoint? {
//        guard var closestPosition = positions.first else { return nil }
//        for position in positions {
//            if distanceFromSpaceship(to: position) < distanceFromSpaceship(to: closestPosition) {
//                closestPosition = position
//            }
//        }
//        return closestPosition
//    }
//
//    private func distanceFromSpaceship(to position: CGPoint) -> CGFloat {
//        return hypot(spaceship.handle.x - position.x,
//                     spaceship.handle.y - position.y)
//    }
//}

