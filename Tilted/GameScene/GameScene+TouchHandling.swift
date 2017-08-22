//
//  GameScene+TouchHandling.swift
//  Tilted
//
//  Created by Lennart Wisbar on 15.08.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        spaceship.updateMovement()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButtonPath.contains(location) {
                let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
                spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
            } else if pauseButtonPath.contains(location) {
                isPaused = true
            }
        }
        moveSpaceshipToClosestBackgroundTouch(event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButtonPath.contains(location) {
                let shootingVector = CGVector(dx: -self.size.width, dy: self.size.height)
                spaceship.startShooting(with: shootingVector, zPosition: ZPositions.shot)
            } else if pauseButtonPath.contains(location) {
                isPaused = true
            } else if fireButtonPath.contains(touch.previousLocation(in: self)) {
                stopShootingIfNoFireButtonTouches(event: event)
            }
        }
        moveSpaceshipToClosestBackgroundTouch(event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if fireButtonPath.contains(location) {
                stopShootingIfNoFireButtonTouches(event: event)
            }
        }
        moveSpaceshipToClosestBackgroundTouch(event: event)
    }
        
    
    // Helpers
    private func moveSpaceshipToClosestBackgroundTouch(event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        let remainingBackgroundTouches = allTouches.filter { $0.phase != .ended && backgroundPath.contains($0.location(in: self)) }
        let positions = remainingBackgroundTouches.map { $0.location(in: self)}
        spaceship.flyingTarget = closestPositionToSpaceship(of: positions)
    }
    
    private func closestPositionToSpaceship(of positions: [CGPoint]) -> CGPoint? {
        let sortedPositions = positions.sorted { distanceFromSpaceship(to: $0) < distanceFromSpaceship(to: $1) }
        return sortedPositions.first
    }
    
    private func distanceFromSpaceship(to position: CGPoint) -> CGFloat {
        return hypot(spaceship.handle.x - position.x,
                     spaceship.handle.y - position.y)
    }
    
    private func stopShootingIfNoFireButtonTouches(event: UIEvent?) {
        guard let allTouches = event?.allTouches else {
            spaceship.stopShooting()
            return
        }
        let remainingFireButtonTouches = allTouches.filter { $0.phase != .ended && fireButtonPath.contains($0.location(in: self)) }
        if remainingFireButtonTouches.isEmpty {
            spaceship.stopShooting()
        }
    }
}
