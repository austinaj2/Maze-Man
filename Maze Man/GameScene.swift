//
//  GameScene.swift
//  Maze Man
//
//  Created by Yabby Yimer Wolle on 4/10/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var imgView = UIImageView(image: UIImage(named: "bg"))
    var block: SKSpriteNode!
    var bgNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate =  self
        
        //background
        bgNode = SKSpriteNode(imageNamed: "bg")
        bgNode.size = CGSize(width: size.width, height: size.height)
        bgNode.anchorPoint = CGPoint(x: 0, y: 0)
        
        //blocks
//        block = SKSpriteNode(imageNamed: "block")
//        block.anchorPoint = CGPoint(x: 0, y: 0)
//        block.position = CGPoint(x: 0, y: 0)
        addChild(bgNode)
//        addChild(block)
        var newX = 0
        while(newX<Int(self.frame.width)) {
            let block = SKSpriteNode(imageNamed: "block")
            block.anchorPoint = CGPoint(x: newX, y: 0)
            block.position = CGPoint(x: newX, y: 0)
            newX = newX + Int(64)
            addChild(block)

//            block = SKSpriteNode(imageNamed: "block")
//            block.position = CGPoint(x: 0, y: block.position.x+block.size.width)
//            addChild(block)
        }

        //add subviews
        // Get label node from scene and store it for use later
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print(t.location(in: self.view))
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
