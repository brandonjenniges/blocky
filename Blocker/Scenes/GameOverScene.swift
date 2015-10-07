//
//  GameOverScene.swift
//  Blocker
//
//  Created by Brandon Jenniges on 10/6/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var gameOverLabel = SKLabelNode(text: "Tap to Play")
    var gameWon: Bool = false {
        didSet {
            gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    override func didMoveToView(view: SKView) {
        gameOverLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        addChild(gameOverLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = view {
            let scene = GameScene(size: view.frame.size)
            view.presentScene(scene)
        }
    }
}
