//
//  NavigationSpace.swift
//  Tilted
//
//  Created by Lennart Wisbar on 26.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

protocol NavigationSpaceDelegate {
    func navigationTouches(at positions: [CGPoint], in sender: NavigationSpace)
    func navigationTouchesEnded()
}

class NavigationSpace: SKSpriteNode {
    var path = CGMutablePath()
    var delegate: NavigationSpaceDelegate?
    
    init(cornerSize: CGSize, in scene: SKScene) {
        let shape = SKShapeNode(rectOf: scene.size)
        let view = SKView()
        let texture = view.texture(from: shape)
        
        super.init(texture: texture, color: .clear, size: scene.size)

        anchorPoint = .zero
        position = .zero
        
        isUserInteractionEnabled = true // So the node can receive touch events
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        let remainingTouches = allTouches.filter { $0.phase != .ended }
        let positions = remainingTouches.map { $0.location(in: self) }
        delegate?.navigationTouches(at: positions, in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        let remainingTouches = allTouches.filter { $0.phase != .ended }
        if remainingTouches.isEmpty {
            delegate?.navigationTouchesEnded()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // guard let allTouches = event?.allTouches else { return }
        // let remainingTouches = allTouches.filter { $0.phase != .ended }
        let positions = touches.map { $0.location(in: self) }
        delegate?.navigationTouches(at: positions, in: self)
    }
    
//    override func contains(_ p: CGPoint) -> Bool {
//        //let translation = CGAffineTransform(translationX: position.x, y: position.y)
//        return path.contains(p) //, transform: translation)
//    }
}
