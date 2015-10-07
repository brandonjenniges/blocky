//
//  Block.swift
//  Blocker
//
//  Created by Brandon Jenniges on 10/6/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "block")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        setupPhysics()
        self.name = BlockCategoryName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        self.physicsBody!.categoryBitMask = BlockCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.friction = 0.0
        self.physicsBody!.affectedByGravity = false
    }
}
