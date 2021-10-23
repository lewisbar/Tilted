//
//  TiltedTests.swift
//  TiltedTests
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Tilted

class TiltedTests: XCTestCase {
    
    func test_lowerRightAngleAboveDiagonal() {
        let size = CGSize(width: 300, height: 700)
        let angle = Int(size.lowerRightAngleAboveDiagonal() * 180 / .pi)    // Convert to degrees
        XCTAssertEqual(angle, 23)
    }
    
    func test_spaceshipSpeedIsInSpaceshipLengthsPerSecond() {
        let ship = Spaceship(in: SKScene())
        ship.position = .zero
        ship.flyingTarget = CGPoint(x: 0, y: 200)
        ship.flyingSpeed = 10
        ship.updateMovement()
        XCTAssertEqual(ship.position, CGPoint(x: 0, y: ship.size.height / 6))
    }
}


