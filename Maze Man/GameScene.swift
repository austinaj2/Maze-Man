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
    var dino1: SKSpriteNode!
    var dino2: SKSpriteNode!
    var player: SKSpriteNode!

    var newX = Int()
    var timer = Timer()
    var timeCount = Int()
    var xPos = [Int]()
    var yPos = [Int]()
    var blockCount = 0
    var taken = [CGPoint]()

    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate =  self
        var incr = 64
        
        //appending for possible locations for random blocks
        while incr<=960 {
            if incr <= 576 {
                xPos.append(incr)
                yPos.append(incr)
            }
            else {
                xPos.append(incr)
            }
            incr+=64
        }
        print(xPos, yPos)

        //background
        bgNode = SKSpriteNode(imageNamed: "bg")
        bgNode.size = CGSize(width: size.width, height: size.height)
        bgNode.anchorPoint = CGPoint(x: 0, y: 0)
        bgNode.zPosition = -1.0
        addChild(bgNode)
        //blocks
        addBlocksRow()
        
        //game status label
        let labelImg = SKSpriteNode(imageNamed: "game-status-panel")
        labelImg.size = CGSize(width: bgNode.size.width, height: 128)
        labelImg.anchorPoint = CGPoint(x: 0, y: 0)
        labelImg.position = CGPoint(x: 0, y: Int(bgNode.frame.maxY)-128)
        labelImg.zPosition = 0.5
        addChild(labelImg)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.position = CGPoint(x: Int(labelImg.frame.width)/2, y: Int(labelImg.frame.maxY+labelImg.frame.minY)/2)
        label.zPosition = 1.0
        label.text = "Hello, Welcome to Maze Man!"
        label.fontSize = 50
        label.fontName = "Avenir"
        label.fontColor = .white
        addChild(label)
        
        //figures
        playerUsed()
        dinos()
        
        
        //timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func addPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //player.physicsBody?.isDynamic = true
        //player.physicsBody?.affectedByGravity = true
        dino1.physicsBody = SKPhysicsBody(rectangleOf: dino1.size)
        dino2.physicsBody = SKPhysicsBody(rectangleOf: dino2.size)
    }
    
    func dinos() {
        var rand = Double(Int.random(in: 1...3))
        //dino1
        dino1 = SKSpriteNode(imageNamed: "dino1")
        dino1.anchorPoint = CGPoint(x: 0, y: 0)
        dino1.name = "dino1"
        dino1.position = CGPoint(x: xPos[xPos.count-1], y: yPos[yPos.count-1])
        dino1.zPosition = 2.0
        dino1.size = CGSize(width: block.size.width, height: block.size.height)
        dino1.xScale = CGFloat(1)
        addChild(dino1)
        
        let dino1moveDown = SKAction.moveBy(x: 0, y: -512, duration: 3)
        let dino1moveUp = SKAction.moveBy(x: 0, y: 512, duration: 3)
        let dino1wait = SKAction.wait(forDuration: rand)
        let groupDino1 = SKAction.sequence([dino1moveDown, dino1moveUp, dino1wait])
        let dino1forever = SKAction.repeatForever(groupDino1)
        dino1.run(dino1forever)
        
        //dino2
        dino2 = SKSpriteNode(imageNamed: "dino2")
        dino2.anchorPoint = CGPoint(x: 0, y: 0)
        dino2.name = "dino2"
        dino2.position = CGPoint(x: xPos[0], y: yPos[3])
        dino2.zPosition = 2.0
        dino2.size = CGSize(width: block.size.width, height: block.size.height)
        dino2.xScale = CGFloat(-1)
        addChild(dino2)
        
        let dino2moveRight = SKAction.moveBy(x: 960, y: 0, duration: 3)
        let dino2moveLeft = SKAction.moveBy(x: -960, y: 0, duration: 3)
        rand = Double(Int.random(in: 1...3))
        let dino2wait = SKAction.wait(forDuration: rand)
        let groupDino2 = SKAction.sequence([dino2moveRight, dino2moveLeft, dino2wait])
        let dino2forever = SKAction.repeatForever(groupDino2)
        dino2.run(dino2forever)
//
    }
    
    func playerUsed() {
        player = SKSpriteNode(imageNamed: "Image")
        player.anchorPoint = CGPoint(x: 0, y: 0)
        player.name = "player"
        player.position = CGPoint(x: block.frame.width, y: block.frame.height)
        player.zPosition = 2.0
        player.size = CGSize(width: block.size.width, height: block.size.height)
        player.xScale = CGFloat(-1)
        addChild(player)
    }
    
    func addBlock(imgName: String, pos: CGPoint) {
        block = SKSpriteNode(imageNamed: imgName)
        block.name = imgName
        block.anchorPoint = CGPoint(x: 0, y: 0)
        if imgName == "water" {
            block.scale(to: CGSize(width: 64, height: 64))
        }
        else {
            block.scale(to: CGSize(width: block.size.width/2, height: block.size.height/2))
        }
        block.position = pos
        block.zPosition = 0
        addChild(block)
    }
    
    func addBlocksRow() {
        let fX = Int(bgNode.frame.maxX)
        
        //bottom row
        var count = 1
        while(newX<fX) {
            if count%6==0 {
                addBlock(imgName: "water", pos: CGPoint(x: newX, y: 0))
            }
            else {
                addBlock(imgName: "block", pos: CGPoint(x: newX, y: 0))
            }
            newX += Int(block.size.width)
            count+=1
        }
        newX = 0
        
        //top rows
        while(newX<fX) {
            addBlock(imgName: "block", pos: CGPoint(x: newX, y: Int(bgNode.frame.maxY)-Int(block.size.height)))
            addBlock(imgName: "block", pos: CGPoint(x: newX, y: Int(bgNode.frame.maxY)-Int(block.size.height)*2))
            newX += Int(block.size.width)
        }
        newX = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print(t.location(in: self.view))
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func timeFormatter(secs: Int) -> (Int, Int) {
        return ((secs%3600)/60, (secs%3600)%60)
    }
    
    func timeStringFormatter(formatted: (Int, Int)) -> String {
        let t = "\(formatted.0):\(String(format: "%02d", formatted.1))"
        return t
    }
    
    @objc func countdown() {
        let form = timeFormatter(secs: timeCount)
        //let timeString = timeStringFormatter(formatted: form)
        if timeCount >= 0 {
            timeCount += 1
            if timeCount > 2 && blockCount < 15 {
                guard let x = xPos.randomElement() else { return }
                guard let y = yPos.randomElement() else { return }
                let playerBounds = CGRect(x: player.position.x, y: player.position.y, width: player.size.width, height: player.size.height)
                if taken.contains(CGPoint(x: x, y: y))==false {
                    taken.append(CGPoint(x: x, y: y))
                    addBlock(imgName: "block", pos: CGPoint(x: x, y: y))
                    print("\(blockCount): \(block.position)")
                    blockCount += 1
                }
            }
        }
        else {
            timer.invalidate()
        }
    }
}
