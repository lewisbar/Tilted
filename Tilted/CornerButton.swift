//
//  CornerButton.swift
//  Tilted
//
//  Created by Lennart Wisbar on 17.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

protocol CornerButtonDelegate {
    func cornerButtonPressed(_ sender: CornerButton)
    func cornerButtonReleased(_ sender: CornerButton)
}

class CornerButton: SKSpriteNode {
    
    var path = CGMutablePath()
    var delegate: CornerButtonDelegate?
    var isPressed = false {
        didSet {
            if isPressed, !oldValue { delegate?.cornerButtonPressed(self)}
            else if !isPressed, oldValue { delegate?.cornerButtonReleased(self)}
        }
    }
    
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    init(size: CGSize, corner: Corner, in scene: SKScene) {
        let a: CGPoint
        let b: CGPoint
        let c: CGPoint
        let anchor: CGPoint
        
        switch corner {
        case .topLeft:
            c = scene.size.topLeft
            a = CGPoint(x: c.x, y: c.y - size.height)
            b = CGPoint(x: c.x + size.width, y: c.y)
            anchor = CGPoint(x: 0, y: 1)
        case .topRight:
            c = scene.size.topRight
            a = CGPoint(x: c.x, y: c.y - size.height)
            b = CGPoint(x: c.x - size.width, y: c.y)
            anchor = CGPoint(x: 1, y: 1)
        case .bottomLeft:
            c = scene.size.bottomLeft
            a = CGPoint(x: c.x + size.width, y: c.y)
            b = CGPoint(x: c.x, y: c.y + size.height)
            anchor = CGPoint(x: 0, y: 0)
        case .bottomRight:
            c = scene.size.bottomRight
            a = CGPoint(x: c.x, y: c.y + size.height)
            b = CGPoint(x: c.x - size.width, y: c.y)
            anchor = CGPoint(x: 1, y: 0)
        }
        
        path.addLines(between: [c, a, b, c])
        
        let shape = SKShapeNode(path: path)
        shape.fillColor = .treePoppy
        
        let view = SKView()
        let texture = view.texture(from: shape)
        
        super.init(texture: texture, color: .clear, size: size)
        anchorPoint = anchor
        position = c
        
        isUserInteractionEnabled = true // So the node can receive touch events
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setIsPressed(accordingTo: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setIsPressed(accordingTo: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setIsPressed(accordingTo: event)
    }
    
    override func contains(_ p: CGPoint) -> Bool {
        let translation = CGAffineTransform(translationX: position.x, y: position.y)
        return path.contains(p, transform: translation)
    }

    private func setIsPressed(accordingTo event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        
        for touch in allTouches {
            if touch.phase != .ended, self.contains(touch.location(in: self)) {
                isPressed = true
                return
            }
        }
        isPressed = false
    }
}
