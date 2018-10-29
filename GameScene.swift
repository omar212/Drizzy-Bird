//
//  GameScene.swift
//  DrizzyBird
//
//  Created by Omar Elnagdy on 3/25/17.
//  Copyright © 2017 Omar Elnagdy. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Physics {
    static let DRAKE : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
    
 }

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var Ground = SKSpriteNode()
    var DRAKE = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var Score = Int()
    let scoreLbl = SKLabelNode()
    
    private var lastUpdateTime : TimeInterval = 0
    //private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        
        self.physicsWorld.contactDelegate = self
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(Score)"
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 8, y: 0 + Ground.frame.height / 8)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = Physics.Ground  // tells whether we are colliding
        Ground.physicsBody?.collisionBitMask = Physics.DRAKE  // Tells whether we are colliding with drake
        Ground.physicsBody?.contactTestBitMask = Physics.DRAKE  //tests whether it did collide
        Ground.physicsBody?.affectedByGravity = true
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
       
        self.addChild(Ground)
        
        DRAKE = SKSpriteNode(imageNamed: "DRAKE")
        DRAKE.size = CGSize(width: 170, height: 180)
        DRAKE.position = CGPoint(x: self.frame.width / 4 - DRAKE.frame.width, y: self.frame.height / 6)
        DRAKE.physicsBody = SKPhysicsBody(circleOfRadius: DRAKE.frame.height / 4)
        DRAKE.physicsBody?.categoryBitMask = Physics.DRAKE
        DRAKE.physicsBody?.collisionBitMask = Physics.Ground | Physics.Wall // collides with both  wall and ground
        DRAKE.physicsBody?.contactTestBitMask = Physics.Ground | Physics.Wall | Physics.Score
        DRAKE.physicsBody?.affectedByGravity = true
        DRAKE.physicsBody?.isDynamic = true
        
        DRAKE.zPosition = 2
        
        self.addChild(DRAKE)
    
    
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == Physics.Score && secondBody.categoryBitMask == Physics.DRAKE || firstBody.categoryBitMask == Physics.DRAKE && secondBody.categoryBitMask == Physics.Score {
            Score+=1
            scoreLbl.text = "\(Score)"
        }
        //if firstBody.categoryBitMask == Physics.Score && secondBody.categoryBitMask == e
    }
    func touchDown(atPoint pos : CGPoint) {
   
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            gameStarted = true
            DRAKE.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance, y: 0, duration:TimeInterval(0.008 * distance))// increasing the number will make it go slower
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            DRAKE.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            DRAKE.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
        
        }
        else{
             DRAKE.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
             DRAKE.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        }
    
        
    }
    
    func createWalls(){
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1,height: 200)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = Physics.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = Physics.DRAKE
        scoreNode.color = UIColor.blue
        
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width,y: self.frame.height / 2 + 400)
        btmWall.position = CGPoint(x: self.frame.width,y: self.frame.height / 2 - 400)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = Physics.Wall
        topWall.physicsBody?.collisionBitMask = Physics.DRAKE
        topWall.physicsBody?.contactTestBitMask = Physics.DRAKE
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = Physics.Wall
        btmWall.physicsBody?.collisionBitMask = Physics.DRAKE
        btmWall.physicsBody?.contactTestBitMask = Physics.DRAKE
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double .pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -100, max: 100)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
       
    }
        
        // Calculate time since last update
}
