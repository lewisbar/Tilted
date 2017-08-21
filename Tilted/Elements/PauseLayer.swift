//
//  PauseLayer.swift
//  Tilted
//
//  Created by Lennart Wisbar on 26.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

protocol PauseLayerDelegate {
    func pauseLayerTouched(_ sender: PauseLayer)
}

class PauseLayer: SKShapeNode {
    var delegate: PauseLayerDelegate?
    
    override init() {
        super.init()
        fillColor = SKColor.lemonYellow.withAlphaComponent(0.3)
        isHidden = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.pauseLayerTouched(self)
    }
}
