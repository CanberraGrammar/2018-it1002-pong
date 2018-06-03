//
//  GameScene.swift
//  Pong
//
//  Created by MPP on 22/5/18.
//  Copyright © 2018 Matthew Purcell. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var topPaddle: SKSpriteNode?
    var bottomPaddle: SKSpriteNode?
    
    var fingerOnTopPaddle: Bool = false
    var fingerOnBottomPaddle: Bool = false
    
    var ball: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        topPaddle = self.childNode(withName: "topPaddle") as? SKSpriteNode

        bottomPaddle = self.childNode(withName: "bottomPaddle") as? SKSpriteNode
        
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        ball!.physicsBody = SKPhysicsBody(rectangleOf: ball!.frame.size)
        ball!.physicsBody!.restitution = 1.0
        ball!.physicsBody!.friction = 0.0
        ball!.physicsBody!.linearDamping = 0.0
        ball!.physicsBody!.angularDamping = 0.0
        
        // Configure the physics world
        // self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
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
    
}
