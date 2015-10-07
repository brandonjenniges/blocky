//
//  Ball.swift
//  Blocker
//
//  Created by Brandon Jenniges on 10/6/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "ball")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        setupPhysics()
        self.name = BallCategoryName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width / 2)
        self.physicsBody?.categoryBitMask = BallCategory
        self.physicsBody?.contactTestBitMask = BottomCategory | BlockCategory
        self.physicsBody?.collisionBitMask = PaddleCategory
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
    }
    
    func tempMethod() {
        // Temp send ball flying
        self.position = CGPointMake(200, 200)
        self.physicsBody!.applyImpulse(CGVectorMake(1, -1))
    }
}
