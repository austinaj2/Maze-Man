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
    var bgNode: SKSpriteNode!
    var dino1: SKSpriteNode!
    var dino2: SKSpriteNode!
    var dino3: SKSpriteNode!
    var dino4: SKSpriteNode!
    var fire: SKSpriteNode!
    var star: SKSpriteNode!
    var swipeGR = UISwipeGestureRecognizer()
    var food: SKSpriteNode!
    var wtrBlocks = [CGPoint]()
    var player: SKSpriteNode!
    var playerBounds = CGRect()
    var starLbl = SKLabelNode()
    var heartLbl = SKLabelNode()
    var batteryLbl = SKLabelNode()
    var rockLbl = SKLabelNode()
    var newX = Int()
    var timer = Timer()
    var timeCount = Int()
    var xPos = [Int]()
    var yPos = [Int]()
    var blockCount = 0
    var taken = [CGPoint]()
    var foodShown = false
    var starShown = false
    var start = CGFloat()
    var other = CGFloat()
    var level = Float()
    var health = 3
    var rocks = 10
    var lbl = SKLabelNode()
    var stars = 0
    var edgeRight = SKNode()
    var edgeRightTouched = false
    var edgeLeftTouched = false
    var topTouched = false
    var groundTouched = false
    var edgeLeft = SKNode()
    var ground = SKNode()
    var top = SKNode()
    var usedDinoAction = [SKAction]()
    var dino3actions = [SKAction]()
    let standard = CGSize(width: 64, height: 64)

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self

        //timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        self.view!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = .down
        self.view!.addGestureRecognizer(swipeDown)
        

        //appending for possible locations for random blocks
        var incr = 96
        while incr<=960 {
            if incr <= 640 {
                xPos.append(incr)
                yPos.append(incr)
            }
            else {
                xPos.append(incr)
            }
            incr+=64
        }
        
        print(yPos)
        
        ground = SKNode()
        ground.position = CGPoint(x: self.size.width/2, y: standard.height)
        addChild(ground)
        
        top = SKNode()
        top.position = CGPoint(x: Int(self.size.width)/2, y: yPos[yPos.count-1]+32)
        addChild(top)
        
        edgeLeft = SKNode()
        edgeLeft.position = CGPoint(x: 0, y: self.size.height/2)
        addChild(edgeLeft)
        
        edgeRight = SKNode()
        edgeRight.position = CGPoint(x: self.size.width, y: self.size.height/2)
        addChild(edgeRight)

        //background
        bgNode = SKSpriteNode(imageNamed: "bg")
        bgNode.size = CGSize(width: size.width, height: size.height)
        bgNode.position = CGPoint(x: size.width/2, y: size.height/2)
        bgNode.zPosition = -1.0
        addChild(bgNode)
        //blocks
        addBlocksRow()
        
        //game status label
        let labelImg = SKSpriteNode(imageNamed: "game-status-panel")
        labelImg.size = CGSize(width: bgNode.size.width, height: 128)
        labelImg.position = CGPoint(x: Int(size.width)/2, y: Int(bgNode.frame.maxY)-64)
        labelImg.zPosition = 1.1
        addChild(labelImg)
        
        lbl = SKLabelNode()
        lbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        lbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        lbl.position = CGPoint(x: Int(labelImg.frame.width)/2, y: Int(labelImg.frame.maxY+labelImg.frame.minY)/2)
        lbl.zPosition = 1.2
        lbl.text = "Hello, Welcome to Maze Man!"
        lbl.fontSize = 50
        lbl.fontName = "Avenir"
        lbl.fontColor = .white
        addChild(lbl)
        
        //heart
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.size = standard
        heart.setScale(0.9)
        heart.position = CGPoint(x: standard.width*2+32, y: standard.width/2)
        heart.zPosition = 1.1
        addChild(heart)
        
        heartLbl = SKLabelNode()
        heartLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        heartLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        heartLbl.position = CGPoint(x: heart.position.x, y: heart.position.y)
        heartLbl.zPosition = 1.2
        heartLbl.text = "\(health)"
        heartLbl.fontSize = 23.5
        heartLbl.fontName = "Avenir"
        heartLbl.fontColor = .white
        addChild(heartLbl)
        
        //rocks
        let rock = SKSpriteNode(imageNamed: "rock")
        rock.size = standard
        rock.setScale(0.9)
        rock.position = CGPoint(x: standard.width+32, y: standard.width/2)
        rock.zPosition = 1.1
        addChild(rock)
        
        rockLbl = SKLabelNode()
        rockLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        rockLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        rockLbl.position = CGPoint(x: rock.position.x, y: rock.position.y)
        rockLbl.zPosition = 1.2
        rockLbl.text = "\(rocks)"
        rockLbl.fontSize = 23.5
        rockLbl.fontName = "Avenir"
        rockLbl.fontColor = .white
        addChild(rockLbl)
        
        //star
        let starCnt = SKSpriteNode(imageNamed: "star")
        starCnt.size = standard
        starCnt.setScale(0.9)
        starCnt.position = CGPoint(x: 32, y: standard.width/2)
        starCnt.zPosition = 1.1
        addChild(starCnt)
        
        starLbl = SKLabelNode()
        starLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        starLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        starLbl.position = CGPoint(x: starCnt.position.x, y: starCnt.position.y-2)
        starLbl.zPosition = 1.2
        starLbl.fontName = "Avenir"
        starLbl.fontSize = 23.5
        starLbl.text = "\(stars)"
        starLbl.fontColor = .black
        addChild(starLbl)
        
        //figures
        playerUsed()
        dinos()
        addPhysics()
        addBitMasks()
        start = dino1.position.x
        other = dino1.position.x+64
        
        //battery
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = Int(UIDevice.current.batteryLevel)*(-100)
        let battery = SKSpriteNode(imageNamed: "battery")
        battery.size = standard
        battery.position = CGPoint(x: standard.width*3+32, y: standard.width/2)
        battery.zPosition = 1.1
        addChild(battery)
        
        batteryLbl = SKLabelNode()
        batteryLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        batteryLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        batteryLbl.position = CGPoint(x: battery.position.x, y: battery.position.y)
        batteryLbl.zPosition = 1.2
        batteryLbl.text = "\(level)"
        batteryLbl.fontSize = 20
        batteryLbl.fontName = "Avenir"
        batteryLbl.fontColor = .black
        addChild(batteryLbl)
    }
    
    @objc func swiped(_ sender: UISwipeGestureRecognizer){
        let st = player.position.x
        let o = player.position.x+64
        if sender.direction == .right {
            let distance = sqrt(pow((self.size.width-player.position.x-32), 2.0) + pow((self.size.width-player.position.y-32), 2.0));
            let go = distance/200
            let acts = SKAction.sequence([SKAction.moveBy(x: self.size.width-player.position.x-32, y: 0, duration: go)])
            let flip1 = SKAction.scaleX(to: CGFloat(-1), duration: 0.0001)
            let gr = SKAction.group([acts, flip1])
            player.removeAction(forKey: "left")
            player.run(gr, withKey: "right")
        }
        if sender.direction == .left {
            let distance = sqrt(pow((0-player.position.x+32), 2.0) + pow((0-player.position.y+32), 2.0));
            let go = distance/200
            let acts = SKAction.sequence([SKAction.moveBy(x: 0-player.position.x+32, y: 0, duration: go)])
            let flip1 = SKAction.scaleX(to: CGFloat(1), duration: 0.0001)
            let gr = SKAction.group([acts, flip1])
            player.removeAction(forKey: "right")
            player.run(gr, withKey: "left")
        }
        if sender.direction == .up {
            
            let gr = SKAction.sequence([SKAction.moveBy(x: 0, y: 64, duration: 0.5), SKAction.moveBy(x: 0, y: -64, duration: 0.75)])
            player.run(gr, withKey: "up")
        }
//        player.removeAllActions()
//        player.run(gr, withKey: "now")
    }
    
    func addBitMasks(){
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Water | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3 | PhysicsCategory.Dino4 | PhysicsCategory.EdgeLeft | PhysicsCategory.EdgeRight | PhysicsCategory.Top | PhysicsCategory.Ground
        player.physicsBody?.contactTestBitMask =  PhysicsCategory.Block
        
        dino1.physicsBody?.categoryBitMask = PhysicsCategory.Dino1
        dino1.physicsBody?.collisionBitMask = PhysicsCategory.Player
        dino1.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
        
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Dino3
        ground.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino3
        
        edgeLeft.physicsBody?.categoryBitMask = PhysicsCategory.EdgeLeft
        edgeLeft.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Dino3
        edgeLeft.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino3
        
        edgeRight.physicsBody?.categoryBitMask = PhysicsCategory.EdgeRight
        edgeRight.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Dino3
        edgeRight.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino3
        
        top.physicsBody?.categoryBitMask = PhysicsCategory.Top
        top.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Dino3
        top.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino3
        
        dino2.physicsBody?.categoryBitMask = PhysicsCategory.Dino2
        dino2.physicsBody?.collisionBitMask = PhysicsCategory.Player
        dino2.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
        
        dino3.physicsBody?.categoryBitMask = PhysicsCategory.Dino3
        dino3.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Block
        dino3.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Block
        
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
//        ground.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Circle
//        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    func gameOver() {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let dino3moveRight = SKAction.moveBy(x: self.size.width-dino3.position.x-32, y: 0, duration: 3)
        let dino3moveLeft = SKAction.moveBy(x: 0-dino3.position.x, y: 0, duration: 3)
        let dino3moveUp = SKAction.moveBy(x: 0, y: CGFloat(yPos[yPos.count-1])-dino3.position.y, duration: 3)
        let dino3moveDown = SKAction.moveBy(x: 0, y: standard.height+32-dino3.position.y, duration: 3)
                
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Fire && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Fire)) {
            player.run(SKAction.moveBy(x: -16, y: 32, duration: 1))
            lbl.text = "Game Over!"
            player.physicsBody?.affectedByGravity = true
            gameOver()
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeRight) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeRight && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Ground) || (contact.bodyA.categoryBitMask == PhysicsCategory.Ground && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeLeft) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeLeft && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Top) || (contact.bodyA.categoryBitMask == PhysicsCategory.Top && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            
            dino3actions.remove(at: dino3actions.firstIndex(of: usedDinoAction[0])!)
            let r = dino3actions.randomElement()
            dino3.run(r!)
            dino3actions.append(usedDinoAction[0])
            usedDinoAction.remove(at: 0)
            usedDinoAction.append(r!)
            lbl.text = "Game Over!"
            //player.physicsBody?.affectedByGravity = true
            gameOver()
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Block) || (contact.bodyA.categoryBitMask == PhysicsCategory.Block && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            
            dino3actions.remove(at: dino3actions.firstIndex(of: usedDinoAction[0])!)
            let r = dino3actions.randomElement()
            dino3.run(r!)
            dino3actions.append(usedDinoAction[0])
            usedDinoAction.remove(at: 0)
            usedDinoAction.append(r!)
            lbl.text = "Game Over!"
            //player.physicsBody?.affectedByGravity = true
            gameOver()
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeRight) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeRight && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            if topTouched == true {
                let choose = [dino3moveDown, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            if groundTouched == true {
                let choose = [dino3moveUp, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            if groundTouched == false && topTouched == false {
                let choose = [dino3moveDown, dino3moveUp, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            edgeRightTouched = true
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeLeft) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeLeft && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            if topTouched == true {
                let choose = [dino3moveDown, dino3moveRight]
                dino3.run(choose.randomElement()!)
            }
            if groundTouched == true {
                let choose = [dino3moveUp, dino3moveRight]
                dino3.run(choose.randomElement()!)
            }
            if groundTouched == false && topTouched == false {
                let choose = [dino3moveDown, dino3moveUp, dino3moveRight]
                dino3.run(choose.randomElement()!)
            }
            edgeLeftTouched = true
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Top) || (contact.bodyA.categoryBitMask == PhysicsCategory.Top && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            if edgeLeftTouched == true {
                let choose = [dino3moveDown, dino3moveRight]
                dino3.run(choose.randomElement()!)
            }
            if edgeRightTouched == true {
                let choose = [dino3moveDown, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            if edgeLeftTouched == false && edgeRightTouched == false {
                let choose = [dino3moveDown, dino3moveRight, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            topTouched = true
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Ground) || (contact.bodyA.categoryBitMask == PhysicsCategory.Ground && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
            if edgeLeftTouched == true {
                let choose = [dino3moveUp, dino3moveRight]
                dino3.run(choose.randomElement()!)
            }
            if edgeRightTouched == true {
                let choose = [dino3moveUp, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            if edgeLeftTouched == false && edgeRightTouched == false {
                let choose = [dino3moveUp, dino3moveRight, dino3moveLeft]
                dino3.run(choose.randomElement()!)
            }
            groundTouched = true
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Fire && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Fire)) {
            player.run(SKAction.moveBy(x: -16, y: 32, duration: 1))
            lbl.text = "Game Over!"
            //player.physicsBody?.affectedByGravity = true
            gameOver()
        }
    }
    
    func addPhysics() {
//        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
//        block.physicsBody?.isDynamic = false
//        block.physicsBody?.affectedByGravity = false
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false

        dino1.physicsBody = SKPhysicsBody(rectangleOf: dino1.size)
        dino1.physicsBody?.affectedByGravity = false
        dino1.physicsBody?.allowsRotation = false
        
        dino2.physicsBody = SKPhysicsBody(rectangleOf: dino2.size)
        dino2.physicsBody?.isDynamic = true
        dino2.physicsBody?.affectedByGravity = false
        dino2.physicsBody?.allowsRotation = false
        
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        top.physicsBody?.isDynamic = false
        top.physicsBody?.affectedByGravity = false
        top.physicsBody?.allowsRotation = false
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.allowsRotation = false
        
        edgeLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.size.height))
        edgeLeft.physicsBody?.isDynamic = false
        edgeLeft.physicsBody?.affectedByGravity = false
        edgeLeft.physicsBody?.allowsRotation = false
        
        edgeRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.size.height))
        edgeRight.physicsBody?.isDynamic = false
        edgeRight.physicsBody?.affectedByGravity = false
        edgeRight.physicsBody?.allowsRotation = false
        
        dino3.physicsBody = SKPhysicsBody(rectangleOf: dino3.size)
        dino3.physicsBody?.isDynamic = true
        dino3.physicsBody?.affectedByGravity = false
        dino3.physicsBody?.allowsRotation = false


    }
    
    func dinos() {
        var rand = Double(Int.random(in: 1...3))
        let randYPos = yPos.randomElement()

        //dino1
        dino1 = SKSpriteNode(imageNamed: "dino1")
        dino1.name = "dino1"
        
        let p = wtrBlocks.randomElement()!
        dino1.position = CGPoint(x: p.x, y: p.y+32)
        taken.append(CGPoint(x: p.x, y: p.y+32))
        dino1.zPosition = 1.0
        dino1.size = CGSize(width: standard.width, height: standard.height)
        dino1.xScale = CGFloat(1)
        addChild(dino1)
        
        let dino1moveDown = SKAction.moveBy(x: 0, y: -576, duration: 3)
        let dino1moveUp = SKAction.moveBy(x: 0, y: 576, duration: 3)
        let dino1wait = SKAction.wait(forDuration: rand)
        let groupDino1 = SKAction.sequence([dino1moveUp, dino1moveDown, dino1wait])
        let dino1forever = SKAction.repeatForever(groupDino1)
        dino1.run(dino1forever)
        
        //dino2
        dino2 = SKSpriteNode(imageNamed: "dino2")
        dino2.name = "dino2"
        dino2.position = CGPoint(x: xPos[xPos.count-1]+128, y: randYPos!)
        dino2.zPosition = 1.0
        dino2.size = CGSize(width: standard.width, height: standard.height)
        dino2.xScale = CGFloat(1)
        addChild(dino2)
        
        let dino2moveRight = SKAction.moveBy(x: 1088, y: 0, duration: 3)
        let dino2moveLeft = SKAction.moveBy(x: -1088, y: 0, duration: 3)
        rand = Double(Int.random(in: 1...3))
        let dino2wait = SKAction.wait(forDuration: rand)
        let gr1 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(-1), duration: 0.1)])
        let gr2 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(1), duration: 0.1)])
        let groupDino2 = SKAction.sequence([dino2moveLeft, gr1, dino2moveRight, gr2])
        let dino2forever = SKAction.repeatForever(groupDino2)
        dino2.run(dino2forever)
        
        //dino3
        dino3 = SKSpriteNode(imageNamed: "dino3")
        dino3.name = "dino3"
        dino3.position = CGPoint(x: 32, y: yPos[yPos.count-1])
        dino3.zPosition = 1.0
        dino3.size = CGSize(width: standard.width, height: standard.height)
        dino3.xScale = CGFloat(1)
//        addChild(dino3)
        
        let dino3moveRight = SKAction.moveBy(x: self.size.width-dino3.position.x-32, y: 0, duration: 3)
        let dino3moveLeft = SKAction.moveBy(x: 0-dino3.position.x+64, y: 0, duration: 3)
        let dino3moveUp = SKAction.moveBy(x: 0, y: CGFloat(yPos[yPos.count-1])-dino3.position.y, duration: 3)
        let dino3moveDown = SKAction.moveBy(x: 0, y: standard.height+32-dino3.position.y, duration: 3)
        dino3actions.append(dino3moveRight)
        dino3actions.append(dino3moveLeft)
        dino3actions.append(dino3moveUp)
        dino3actions.append(dino3moveDown)
        dino3.run(dino3moveRight)
        usedDinoAction.append(dino3moveRight)


//        let gr1 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(-1), duration: 0.1)])
//        let gr2 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(1), duration: 0.1)])
//        let groupDino2 = SKAction.sequence([dino2moveLeft, gr1, dino2moveRight, gr2])
//        let dino2forever = SKAction.repeatForever(groupDino2)
        
        //dino4
        dino4 = SKSpriteNode(imageNamed: "dino4")
        dino4.name = "dino4"
        dino4.position = CGPoint(x: 32, y: yPos[yPos.count-1]+64)
        taken.append(CGPoint(x: 0, y: yPos[yPos.count-1]+128))
        dino4.zPosition = 1.2
        dino4.size = CGSize(width: standard.width*(4/3), height: standard.height)
        dino4.xScale = CGFloat(1)
        addChild(dino4)
        
        let dino4moveRight = SKAction.moveBy(x: 960, y: 0, duration: 2.2)
        let dino4moveLeft = SKAction.moveBy(x: -960, y: 0, duration: 2.2)
        let dino4slowerRight = SKAction.moveBy(x: 960, y: 0, duration: 3)
        let dino4slowerLeft = SKAction.moveBy(x: -960, y: 0, duration: 3)
        let groupDino4 = SKAction.sequence([dino4moveRight, dino4moveLeft, dino4slowerRight, dino4slowerLeft])
        let dino4forever = SKAction.repeatForever(groupDino4)
        dino4.run(dino4forever)
    }
    
    func showFood(pos: CGPoint) {
        food = SKSpriteNode(imageNamed: "food")
        food.name = "food"
        food.position = pos
        taken.append(pos)
        food.zPosition = 1.0
        food.size = CGSize(width: standard.width, height: standard.height)
        addChild(food)
        foodShown = true
    }
    
    func showStar(pos: CGPoint) {
        star = SKSpriteNode(imageNamed: "star")
        star.name = "star"
        star.position = pos
        taken.append(pos)
        star.zPosition = 1.0
        star.size = CGSize(width: standard.width, height: standard.height)
        addChild(star)
        starShown = true
    }
    
    func throwFire() {
        fire = SKSpriteNode(imageNamed: "fire")
        fire.name = "fire"
        fire.position = dino4.position
        fire.zPosition = 1.2
        fire.size = CGSize(width: standard.width, height: standard.height)
        addChild(fire)
        
        //physics
        fire.physicsBody = SKPhysicsBody(circleOfRadius: fire.size.width/2)
        fire.physicsBody?.isDynamic = true
        fire.physicsBody?.affectedByGravity = false
        fire.physicsBody?.allowsRotation = false
        fire.physicsBody?.categoryBitMask = PhysicsCategory.Fire
        fire.physicsBody?.collisionBitMask = 0
        fire.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
        
        
        if fire.position.y < 0 {
            fire.removeFromParent()
        }
        
        let fireDown = SKAction.moveBy(x: 0, y: -960, duration: 3)
//        let groupDino4 = SKAction.sequence([dino4moveRight, dino4moveLeft, dino4wait])
        fire.run(fireDown)
        if fire.position.y < 0 {
            fire.removeFromParent()
        }
    }
    
    func playerUsed() {
        player = SKSpriteNode(imageNamed: "caveman")
        player.name = "player"
        player.zPosition = 1.0
        player.size = CGSize(width: standard.width, height: standard.height)
        player.xScale = CGFloat(-1)
        player.position = CGPoint(x: standard.width/2, y: standard.height+32)
        taken.append(player.position)

        addChild(player)
    }
    
    func addBlock(imgName: String, pos: CGPoint) {
        if imgName == "water" {
            let water = SKSpriteNode(imageNamed: imgName)
            water.size = standard
            water.zPosition = 1.1
            water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
            water.physicsBody?.affectedByGravity = false
            water.physicsBody?.categoryBitMask = PhysicsCategory.Water
            water.physicsBody?.collisionBitMask = PhysicsCategory.Player
            water.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
            water.position = pos
            taken.append(water.position)
            addChild(water)
        }
        else {
            let block = SKSpriteNode(imageNamed: imgName)
            block.size = standard
            block.zPosition = 1.0
            block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block
            block.physicsBody?.collisionBitMask = PhysicsCategory.Player
            block.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
            block.position = pos
            taken.append(block.position)
            addChild(block)
        }
    }
    
    func addBlocksRow() {
        let fX = Int(bgNode.frame.maxX)
        
        //bottom row
        var count = 1
        newX = 32
        while(newX<fX) {
            if count%6==0 {
                addBlock(imgName: "water", pos: CGPoint(x: newX, y: 31))
                wtrBlocks.append(CGPoint(x: newX, y: 0))
            }
            else {
                addBlock(imgName: "block", pos: CGPoint(x: newX, y: 31))
            }
            newX += Int(standard.width)
            count+=1
        }
        newX = 32
        
        //top rows
        while(newX<fX) {
            addBlock(imgName: "block", pos: CGPoint(x: newX, y: Int(bgNode.frame.maxY)-Int(standard.height)/2+1))
            addBlock(imgName: "block", pos: CGPoint(x: newX, y: Int(bgNode.frame.maxY)-(Int(standard.height)/2)-64+1))
            newX += Int(standard.width)
        }
        newX = 32
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print(t.location(in: self.view))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if dino2.position.x > dino1.position.x && dino1.position.y == 0  {
            dino1.position.x = other
            let flip1 = SKAction.scaleX(to: CGFloat(-1), duration: 0.0001)
            dino1.run(flip1)
        }
        else {
            dino1.position.x = start
            let flip1 = SKAction.scaleX(to: CGFloat(1), duration: 0.0001)
            dino1.run(flip1)
        }
    }
    
    func timeFormatter(secs: Int) -> (Int, Int) {
        return ((secs%3600)/60, (secs%3600)%60)
    }
    
    func timeStringFormatter(formatted: (Int, Int)) -> String {
        let t = "\(formatted.0):\(String(format: "%02d", formatted.1))"
        return t
    }
    
    @objc func countdown() {
        //let form = timeFormatter(secs: timeCount)
        //let timeString = timeStringFormatter(formatted: form)
        if timeCount >= 0 {
            guard let xFood = xPos.randomElement() else { return }
            guard let yFood = yPos.randomElement() else { return }
            guard let xStar = xPos.randomElement() else { return }
            guard let yStar = yPos.randomElement() else { return }
            
            if foodShown == false && taken.contains(CGPoint(x: xFood, y: yFood))==false && blockCount >= 10 {
                showFood(pos: CGPoint(x: xFood, y: yFood))
                taken.append(CGPoint(x: xFood, y: yFood))
            }
            if starShown == false && taken.contains(CGPoint(x: xStar, y: yStar))==false && blockCount >= 10 {
                showStar(pos: CGPoint(x: xStar, y: yStar))
                taken.append(CGPoint(x: xStar, y: yStar))
            }
            
            //incrementing time by 1 second
            timeCount += 1
            playerBounds = CGRect(x: player.position.x, y: player.position.y, width: player.size.width, height: player.size.height)
            
            //starting at 3rd second, create blocks until 15 blocks are made
            if timeCount > 2 && blockCount < 15 {
                guard let x = xPos.randomElement() else { return }
                guard let y = yPos.randomElement() else { return }
                if taken.contains(CGPoint(x: x, y: y))==false {
                    taken.append(CGPoint(x: x, y: y))
                    addBlock(imgName: "block", pos: CGPoint(x: x, y: y))
                    blockCount += 1
                }
            }
            // every random 5th-10th second, fire a ball from dino4
            if timeCount%Int.random(in: 5...10) == 0 {
                throwFire()
            }
            if timeCount%2==0 && timeCount > 1 {
                edgeRightTouched = false
                edgeLeftTouched = false
                topTouched = false
                groundTouched = false
            }
            
            
        }
        else {
            timer.invalidate()
        }
    }
    
    struct PhysicsCategory {
        static let Player: UInt32 = 0x1 << 0
        static let Food: UInt32 = 0x1 << 1
        static let Star: UInt32 = 0x1 << 2
        static let Dino1: UInt32 = 0x1 << 3
        static let Dino2: UInt32 = 0x1 << 4
        static let Dino3: UInt32 = 0x1 << 5
        static let Dino4: UInt32 = 0x1 << 6
        static let Water: UInt32 = 0x1 << 7
        static let Fire: UInt32 = 0x1 << 8
        static let Rock: UInt32 = 0x1 << 9
        static let Block: UInt32 = 0x1 << 10
        static let Ground: UInt32 = 0x1 << 11
        static let EdgeRight: UInt32 = 0x1 << 12
        static let EdgeLeft: UInt32 = 0x1 << 13
        static let Top: UInt32 = 0x1 << 14

    }
}
