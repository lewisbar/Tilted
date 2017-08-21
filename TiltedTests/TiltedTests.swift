//
//  TiltedTests.swift
//  TiltedTests
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import XCTest
@testable import Tilted

class TiltedTests: XCTestCase {
    
    func test_lowerRightAngleAboveDiagonal() {
        let size = CGSize(width: 300, height: 700)
        let angle = Int(size.lowerRightAngleAboveDiagonal() * 180 / .pi)    // Convert to degrees
        XCTAssertEqual(angle, 23)
    }
    
    
}


