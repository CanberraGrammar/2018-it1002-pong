//
//  GameScene.swift
//  Pong
//
//  Created by MPP on 22/5/18.
//  Copyright © 2018 Matthew Purcell. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory: UInt32 = 0x1 << 0
    let BottomCategory: UInt32 = 0x1 << 1
    let TopCategory: UInt32 = 0x1 << 2
    
    var topPaddle: SKSpriteNode?
    var bottomPaddle: SKSpriteNode?
    
    var topScore: SKLabelNode?
    var bottomScore: SKLabelNode?
    
    var fingerOnTopPaddle: Bool = false
    var fingerOnBottomPaddle: Bool = false
    
    var ball: SKSpriteNode?
    
    var gameRunning: Bool = false
    
    var topScoreCount: Int = 0
    var bottomScoreCount: Int = 0
    
    override func didMove(to view: SKView) {
        
        topPaddle = self.childNode(withName: "topPaddle") as? SKSpriteNode
        topPaddle!.physicsBody = SKPhysicsBody(rectangleOf: topPaddle!.frame.size)
        topPaddle!.physicsBody!.isDynamic = false

        bottomPaddle = self.childNode(withName: "bottomPaddle") as? SKSpriteNode
        bottomPaddle!.physicsBody = SKPhysicsBody(rectangleOf: bottomPaddle!.frame.size)
        bottomPaddle!.physicsBody!.isDynamic = false
        
        topScore = self.childNode(withName: "topScore") as? SKLabelNode
        bottomScore = self.childNode(withName: "bottomScore") as? SKLabelNode
        
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        ball!.physicsBody = SKPhysicsBody(rectangleOf: ball!.frame.size)
        ball!.physicsBody!.restitution = 1.0
        ball!.physicsBody!.friction = 0.0
        ball!.physicsBody!.linearDamping = 0.0
        ball!.physicsBody!.angularDamping = 0.0
        ball!.physicsBody!.allowsRotation = false
        ball!.physicsBody!.categoryBitMask = BallCategory
        ball!.physicsBody!.contactTestBitMask = TopCategory | BottomCategory
        
        // Configure the physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Points
        let topLeftPoint = CGPoint(x: -(size.width / 2), y: size.height / 2)
        let topRightPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        let bottomLeftPoint = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
        let bottomRightPoint = CGPoint(x: size.width / 2, y: -(size.height / 2))
        
        // Top node
        let topNode = SKNode()
        topNode.physicsBody = SKPhysicsBody(edgeFrom: topLeftPoint, to: topRightPoint)
        topNode.physicsBody!.categoryBitMask = TopCategory
        addChild(topNode)
        
        // Bottom node
        let bottomNode = SKNode()
        bottomNode.physicsBody = SKPhysicsBody(edgeFrom: bottomLeftPoint, to: bottomRightPoint)
        bottomNode.physicsBody!.categoryBitMask = BottomCategory
        addChild(bottomNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if touchedNode.name == "topPaddle" {
            fingerOnTopPaddle = true
        }
        
        if touchedNode.name == "bottomPaddle" {
            fingerOnBottomPaddle = true
        }
        
        if gameRunning == false {
            
            let randomNumber = Int(arc4random_uniform(2))
            
            if randomNumber == 0 {
            
                ball!.physicsBody!.applyImpulse(CGVector(dx: 5, dy: 5))
                
            }
            
            else {
                
                ball!.physicsBody!.applyImpulse(CGVector(dx: -5, dy: -5))
                
            }
            
            gameRunning = true

        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let previousTouchLocation = touch.previousLocation(in: self)
        
        if fingerOnTopPaddle == true && touchLocation.y > 0 {
            let paddleX = topPaddle!.position.x + (touchLocation.x - previousTouchLocation.x)
            
            if ((paddleX - (topPaddle!.size.width / 2)) > -(self.size.width / 2)) && ((paddleX + (topPaddle!.size.width / 2)) < (self.size.width / 2)) {
                topPaddle!.position = CGPoint(x: paddleX, y: topPaddle!.position.y)
            }
            
        }
        
        if fingerOnBottomPaddle == true && touchLocation.y < 0 {
            let paddleX = bottomPaddle!.position.x + (touchLocation.x - previousTouchLocation.x)
            
            if ((paddleX - (bottomPaddle!.size.width / 2)) > -(self.size.width / 2)) && ((paddleX + (bottomPaddle!.size.width / 2)) < (self.size.width / 2)) {
                bottomPaddle!.position = CGPoint(x: paddleX, y: bottomPaddle!.position.y)
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if fingerOnTopPaddle == true {
            fingerOnTopPaddle = false
        }
        
        if fingerOnBottomPaddle == true {
            fingerOnBottomPaddle = false
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func resetGame() {
        
        // Reset the ball position to the middle
        ball!.position.x = 0
        ball!.position.y = 0
        
        // Reset physics
        ball!.physicsBody!.isDynamic = false
        ball!.physicsBody!.isDynamic = true
        
        // Reset the paddle positions
        topPaddle!.position.x = 0
        bottomPaddle!.position.x = 0
        
        // Reset gameRunning variable
        gameRunning = false
        
        // Unpause the game
        view!.isPaused = false
        
    }
    
    func gameOver() {
        
        view!.isPaused = true
        
        let gameOverAlert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        
        let gameOverAction = UIAlertAction(title: "Okay", style: .default) { (theAlertAction) in
            
            self.resetGame()
            
        }
        
        gameOverAlert.addAction(gameOverAction)
        
        view!.window!.rootViewController!.present(gameOverAlert, animated: true, completion: nil)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == TopCategory) || (contact.bodyB.categoryBitMask == TopCategory) {
            
            print("Top Contact")
            
            bottomScoreCount += 1
            bottomScore!.text = String(bottomScoreCount)
            
            gameOver()
            
        }
        
        else if (contact.bodyA.categoryBitMask == BottomCategory) || (contact.bodyB.categoryBitMask == BottomCategory) {
            
            print("Bottom Contact")
            
            topScoreCount += 1
            topScore!.text = String(topScoreCount)
            
            gameOver()
            
        }
        
    }
    
}

















