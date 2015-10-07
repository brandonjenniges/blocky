//
//  Paddle.swift
//  Blocker
//
//  Created by Brandon Jenniges on 10/6/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Paddle: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "paddle")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        setupPhysics()
        self.name = PaddleCategoryName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.frame.size)
        self.physicsBody?.categoryBitMask = PaddleCategory
        self.physicsBody?.dynamic = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
    }
}
