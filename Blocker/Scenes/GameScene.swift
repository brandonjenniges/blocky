//
//  GameScene.swift
//  blocker
//
//  Created by Brandon Jenniges on 10/5/15.
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let BlockNodeCategoryName = "blockNode"

let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BlockCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var lastUpdateTime: NSTimeInterval?
    var dt: NSTimeInterval?
    
    var ball: Ball!
    var paddle: Paddle!
    
    var isFingerOnPaddle = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        setupWorldPhysics()
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody?.categoryBitMask = BottomCategory
        addChild(bottom)
        
        self.view!.showsPhysics = true
        
        ball = Ball()
        self.addChild(ball)
        
        paddle = Paddle()
        paddle.position = CGPointMake(200, 50)
        self.addChild(paddle)
        
        ball.tempMethod()
        print(self.frame)
        
        addBlocks()

    }
    
    override func update(currentTime: NSTimeInterval) {
        let maxSpeed: CGFloat = 1000.0
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        }
        else {
            ball.physicsBody!.linearDamping = 0.0
        }
    }
    
    func setupWorldPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        setupWorldPhysicsBarriers()
    }
    
    func setupWorldPhysicsBarriers() {
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
    }
    
    
    //MARK: Touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! 
        let touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                print("Began touch")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isFingerOnPaddle {
            let touch = touches.first!
            let touchLocation = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            paddleX = max(paddleX, paddle.size.width / 2)
            paddleX = min(paddleX, size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    //MARK: Contact Delegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom... Game over...")
            finishGame(false)
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            print("Hit block..")
            secondBody.node!.removeFromParent()
            if isGameWon() {
                finishGame(true)
            }
        }
    }
    
    //MARK: Add blocks
    func addBlocks() {
        let numberOfBlocks = 5
        let blockWidth = SKSpriteNode(imageNamed: "block.png").size.width
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
        
        let padding: CGFloat = 10.0
        let totalPadding = padding * CGFloat(numberOfBlocks - 1)
        
        let xOffset = (CGRectGetWidth(frame) - totalBlocksWidth - totalPadding) / 2
        
        for index in 0..<numberOfBlocks {
            let block = Block()
            block.position = CGPointMake(xOffset + CGFloat(CGFloat(index) + 0.5)*blockWidth + CGFloat(index-1)*padding, CGRectGetHeight(frame) * 0.8)
            addChild(block)
        }
    }
    
    //MARK: Scoring
    func isGameWon() -> Bool {
        self.enumerateChildNodesWithName(BlockCategoryName) {
            node, stop in
            return false
        }
        return true
    }
    
    func finishGame(gameWon:Bool) {
        if let view = view {
            let scene = GameOverScene(size: view.frame.size)
            scene.gameWon = gameWon
            view.presentScene(scene)
        }
    }
}
