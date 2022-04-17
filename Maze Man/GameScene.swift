//
//  GameScene.swift
//  Maze Man
//
//  Created by Yabby Yimer Wolle on 4/10/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var highScores = [HighScore]()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var imgView = UIImageView(image: UIImage(named: "bg"))
    var bgNode: SKSpriteNode!
    var dino1: SKSpriteNode!
    var dino2: SKSpriteNode!
    var showDino1 = false
    var showDino2 = false
    var showDino3 = false
    var dino1reappear = Int()
    var dino2reappear = Int()
    var dino3reappear = Int()
    var dino3: SKSpriteNode!
    var reappear = Int()
    var dino4: SKSpriteNode!
    var fire: SKSpriteNode!
    var thrownRock: SKSpriteNode!
    var star: SKSpriteNode!
    var swipeGR = UISwipeGestureRecognizer()
    var food: SKSpriteNode!
    var wtrBlocks = [CGPoint]()
    var player: SKSpriteNode!
    var playerBounds = CGRect()
    var starLbl = SKLabelNode()
    var heartLbl = SKLabelNode()
    var energyLbl = SKLabelNode()
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
    var level = 100
    var tap = UITapGestureRecognizer()
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
    var sound: SKAction?
    var death: SKAction?
    let standard = CGSize(width: 64, height: 64)

    
    override func didMove(to view: SKView) {
//        sound.autoplayLooped = false
//        addChild(sound)
//        death.autoplayLooped = false
//        addChild(death)
        sound = SKAction.playSoundFileNamed("bite", waitForCompletion: false)
        death = SKAction.playSoundFileNamed("death", waitForCompletion: false)
//        sound.autoplayLooped = false
//        death.autoplayLooped = false
//        addChild(sound)
//        addChild(death)

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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view!.addGestureRecognizer(tap)
        

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
        starCnt.position = CGPoint(x: 30, y: standard.width/2)
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
        dino1stuff()
        dino2stuff()
        start = dino1.position.x
        other = dino1.position.x+64
        
        //energy
        let energy = SKSpriteNode(imageNamed: "battery")
        energy.size = standard
        energy.position = CGPoint(x: standard.width*3+32, y: standard.width/2)
        energy.zPosition = 1.1
        addChild(energy)
        
        energyLbl = SKLabelNode()
        energyLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        energyLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        energyLbl.position = CGPoint(x: energy.position.x, y: energy.position.y)
        energyLbl.zPosition = 1.2
        energyLbl.text = "\(100)"
        energyLbl.fontSize = 20
        energyLbl.fontName = "Avenir"
        energyLbl.fontColor = .black
        addChild(energyLbl)
        
        addPhysics()
        addBitMasks()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let t = sender.location(in: self.view)
        throwRock(pos: t)
    }
    
    @objc func swiped(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .right {
            let distance = sqrt(pow((self.size.width-player.position.x-32), 2.0) + pow((self.size.width-player.position.y-32), 2.0));
            let go = distance/200
            let acts = SKAction.sequence([SKAction.moveBy(x: self.size.width-player.position.x-32, y: 0, duration: go)])
            let flip1 = SKAction.scaleX(to: CGFloat(-1), duration: 0.0001)
            let gr = SKAction.group([acts, flip1])
            player.removeAllActions()
            player.run(gr, withKey: "right")
        }
        if sender.direction == .left {
            let distance = sqrt(pow((0-player.position.x+32), 2.0) + pow((0-player.position.y+32), 2.0));
            let go = distance/200
            let acts = SKAction.sequence([SKAction.moveBy(x: 0-player.position.x+32, y: 0, duration: go)])
            let flip1 = SKAction.scaleX(to: CGFloat(1), duration: 0.0001)
            let gr = SKAction.group([acts, flip1])
            player.removeAllActions()
            player.run(gr, withKey: "left")
        }
        if sender.direction == .up {
            let distance = sqrt(pow((CGFloat(yPos[yPos.count-1])-player.position.y), 2.0) + pow((CGFloat(yPos[yPos.count-1])-player.position.y), 2.0));
            let go = distance/200
            let gr = SKAction.sequence([SKAction.moveBy(x: 0, y: CGFloat(yPos[yPos.count-1])-player.position.y, duration: go)])
            player.removeAllActions()
            player.run(gr, withKey: "up")
        }
        if sender.direction == .down {
            let distance = sqrt(pow((standard.height+32-player.position.y), 2.0) + pow((standard.height+32-player.position.y), 2.0));
            let go = distance/200
            let gr = SKAction.sequence([SKAction.moveBy(x: 0, y: standard.height+32-player.position.y, duration: go)])
            player.removeAllActions()
            player.run(gr, withKey: "down")
            if player.position.y > 0 {
                
            }
        }
//        player.removeAllActions()
//        player.run(gr, withKey: "now")
    }
    
    func addBitMasks(){
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.EdgeLeft | PhysicsCategory.EdgeRight | PhysicsCategory.Top | PhysicsCategory.Ground
        player.physicsBody?.contactTestBitMask =  PhysicsCategory.Block
        
        
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
                
        dino3.physicsBody?.categoryBitMask = PhysicsCategory.Dino3
        dino3.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Block | PhysicsCategory.EdgeLeft | PhysicsCategory.EdgeRight | PhysicsCategory.Top | PhysicsCategory.Ground
        dino3.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Block | PhysicsCategory.EdgeLeft | PhysicsCategory.EdgeRight | PhysicsCategory.Top | PhysicsCategory.Ground
        
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
//        ground.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Circle
//        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    }
    
    func gameOver() {
        health = 0
        level = 0
        lbl.fontColor = .red
        lbl.text = "Game Over!"
        timer.invalidate()
        timeCount = 0
        player.physicsBody?.collisionBitMask = PhysicsCategory.Star | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = true
        dino1.removeFromParent()
        dino2.removeFromParent()
        if let d = UserDefaults.standard.object(forKey: "studentData") as? Data {
            highScores = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(d) as! [HighScore]
            if let dataToSave = try? NSKeyedArchiver.archivedData(withRootObject: highScores, requiringSecureCoding: false)
            {
                UserDefaults.standard.set(dataToSave, forKey: "studentData")
            }
        }
        
        let flipTransition = SKTransition.fade(withDuration: 2.0)
        let door = SKTransition.fade(withDuration: 1.0)
        let n = HighScore(score: stars)
        if highScores.count < 3 &&  highScores.contains(n)==false {
            highScores.append(n)
        }
        var final = [Int]()
        for i in highScores {
            if final.count < 3 && final.contains(i.score)==false {
                final.append(i.score)
            }
        }
        let gameOverScene = GameOverScene(size: self.size, score: stars, past: final, highScore: false)
        playDeath()
        gameOverScene.scaleMode = .aspectFill
        self.run(.wait(forDuration: 2))
        self.view?.presentScene(gameOverScene, transition: door)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var actions = [SKAction]()
        
        var distance = sqrt(pow((standard.width+32-dino3.position.y), 2.0) + pow(standard.width+32-dino3.position.y, 2.0));
        var go = distance/200
        var acts = SKAction.sequence([SKAction.moveBy(x: 0, y: standard.width+32-dino3.position.y, duration: go)])
        let down = SKAction.group([acts])
        actions.append(down)
        
        distance = sqrt(pow((0-player.position.x+32), 2.0) + pow((0-player.position.y+32), 2.0));
        go = distance/200
        acts = SKAction.sequence([SKAction.moveBy(x: 0-player.position.x+32, y: 0, duration: go)])
        var flip1 = SKAction.scaleX(to: CGFloat(1), duration: 0.0001)
        let left = SKAction.group([acts, flip1])
        actions.append(left)
        
        distance = sqrt(pow((self.size.width-player.position.x-32), 2.0) + pow((self.size.width-player.position.y-32), 2.0));
        go = distance/200
        acts = SKAction.sequence([SKAction.moveBy(x: self.size.width-player.position.x-32, y: 0, duration: go)])
        flip1 = SKAction.scaleX(to: CGFloat(-1), duration: 0.0001)
        let right = SKAction.group([acts, flip1])
        actions.append(right)
        
        distance = sqrt(pow((standard.width+32-dino3.position.y), 2.0) + pow(standard.width+32-dino3.position.y, 2.0));
        go = distance/200
        acts = SKAction.sequence([SKAction.moveBy(x: 0, y: CGFloat(yPos[yPos.count-1])-dino3.position.y+96, duration: go)])
        let up = SKAction.group([acts])
        actions.append(up)
                
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeRight) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeRight && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Ground) || (contact.bodyA.categoryBitMask == PhysicsCategory.Ground && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeLeft) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeLeft && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Top) || (contact.bodyA.categoryBitMask == PhysicsCategory.Top && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
//
//            dino3actions.remove(at: dino3actions.firstIndex(of: usedDinoAction[0])!)
//            let r = dino3actions.randomElement()
//            dino3.run(r!)
//            dino3actions.append(usedDinoAction[0])
//            usedDinoAction.remove(at: 0)
//            usedDinoAction.append(r!)
//        }
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Block) || (contact.bodyA.categoryBitMask == PhysicsCategory.Block && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
//
//            actions.remove(at: actions.count-1)
//            dino3.removeAllActions()
//            let n = actions.randomElement()!
//            dino3.run(n, withKey: "left")
//            actions.append(n)
//        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Water && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Water)) {
            gameOver()
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Food && contact.bodyB.categoryBitMask == PhysicsCategory.Dino1) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.Food)) {
            bite()
            foodShown = false
            food.removeFromParent()
            reappear = 10
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Food && contact.bodyB.categoryBitMask == PhysicsCategory.Dino2) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.Food)) {
            bite()
            foodShown = false
            food.removeFromParent()
            reappear = 10
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Food && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Food)) {
            bite()
            foodShown = false
            food.removeFromParent()
            reappear = 10
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Dino2)) {
            if let action = player.action(forKey: "left") {
                action.speed = 0
            }
            if let action = player.action(forKey: "right") {
                action.speed = 0
            }
            if let action = player.action(forKey: "up") {
                action.speed = 0
            }
            if let action = player.action(forKey: "down") {
                action.speed = 0
            }
            bite()
            player.run(SKAction.sequence([SKAction.moveBy(x: 32, y: 0, duration: 0.5/3), SKAction.moveBy(x: -32, y: 0, duration: 0.5/3), SKAction.moveBy(x: 32, y: 0, duration: 0.5/3)]))
            if level > 80 {
                level -= 80
            }
            else {
                level = 100+(level-80)
                if health > 0 {
                    health -= 1
                }
                else {
                    gameOver()
                }
            }
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Fire && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Fire)) {
            if let action = player.action(forKey: "left") {
                action.speed = 0
            }
            if let action = player.action(forKey: "right") {
                action.speed = 0
            }
            if let action = player.action(forKey: "up") {
                action.speed = 0
            }
            if let action = player.action(forKey: "down") {
                action.speed = 0
            }
            player.run(SKAction.sequence([SKAction.moveBy(x: 32, y: 0, duration: 0.5/3), SKAction.moveBy(x: -32, y: 0, duration: 0.5/3), SKAction.moveBy(x: 32, y: 0, duration: 0.5/3)]))
            if health > 0 {
                health -= 1
            }
            else {
                gameOver()
            }
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Dino1)) {
            if let action = player.action(forKey: "left") {
                action.speed = 0
            }
            if let action = player.action(forKey: "right") {
                action.speed = 0
            }
            if let action = player.action(forKey: "up") {
                action.speed = 0
            }
            if let action = player.action(forKey: "down") {
                action.speed = 0
            }
            bite()
            player.run(SKAction.sequence([SKAction.moveBy(x: 32, y: 0, duration: 0.5/3), SKAction.moveBy(x: -32, y: 0, duration: 0.5/3), SKAction.moveBy(x: 32, y: 0, duration: 0.5/3)]))
            if level > 60 {
                level -= 60
            }
            else {
                level = 100+(level-60)
                if health > 0 {
                    health -= 1
                }
                else {
                    gameOver()
                }
            }
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Star && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Star)) {
            bite()
            starShown = false
            star.removeFromParent()
            stars += 1
            starLbl.fontColor = .green
            lbl.fontColor = .green
            lbl.text = "You got a star!"
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Rock && contact.bodyB.categoryBitMask == PhysicsCategory.Dino1) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyB.categoryBitMask == PhysicsCategory.Rock)) {
            dino1.physicsBody?.affectedByGravity = true
            dino1.physicsBody?.contactTestBitMask = 0
            dino1.physicsBody?.allowsRotation = true
            showDino1 = false
            if dino1.position.y < 0 {
                dino1.removeFromParent()
            }
            dino1reappear = Int.random(in: 1...5)
            lbl.fontColor = .red
            lbl.text = "Enemy Killed!"
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Rock && contact.bodyB.categoryBitMask == PhysicsCategory.Fire) || (contact.bodyA.categoryBitMask == PhysicsCategory.Fire && contact.bodyB.categoryBitMask == PhysicsCategory.Rock)) {
            fire.physicsBody?.affectedByGravity = true
            fire.physicsBody?.contactTestBitMask = 0
            fire.physicsBody?.allowsRotation = true
            lbl.fontColor = .red
            lbl.text = "Whew... close one!"
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Rock && contact.bodyB.categoryBitMask == PhysicsCategory.Dino2) || (contact.bodyA.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyB.categoryBitMask == PhysicsCategory.Rock)) {
            dino2.physicsBody?.affectedByGravity = true
            dino2.physicsBody?.contactTestBitMask = 0
            dino2.physicsBody?.allowsRotation = true
            showDino2 = false
            if dino2.position.y < 0 {
                dino2.removeFromParent()
            }
            dino2reappear = Int.random(in: 1...5)
            lbl.fontColor = .red
            lbl.text = "Enemy Killed!"
        }
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Food && contact.bodyB.categoryBitMask == PhysicsCategory.Player) || (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Food)) {
            bite()
            foodShown = false
            food.removeFromParent()
            if level <= 50 {
                level += 50
            }
            else {
                level = 100
            }
            reappear = 0
        }
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeRight) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeRight && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
////            if topTouched == true {
////                let choose = [dino3moveDown, dino3moveLeft]
////                dino3.run(choose.randomElement()!)
////            }
////            if groundTouched == true {
////                let choose = [dino3moveUp, dino3moveLeft]
////                dino3.run(choose.randomElement()!)
////            }
////            if groundTouched == false && topTouched == false {
////                let choose = [dino3moveDown, dino3moveUp, dino3moveLeft]
////                dino3.run(choose.randomElement()!)
////            }
////            edgeRightTouched = true
////            let distance = sqrt(pow((0-player.position.x+32), 2.0) + pow((0-player.position.y+32), 2.0));
////            let go = distance/200
////            let acts = SKAction.sequence([SKAction.moveBy(x: 0-player.position.x+32, y: 0, duration: go)])
////            let flip1 = SKAction.scaleX(to: CGFloat(1), duration: 0.0001)
////            let gr = SKAction.group([acts, flip1])
//            actions.remove(at: actions.firstIndex(of: right)!)
//            dino3.removeAllActions()
//            dino3.run(actions.randomElement()!, withKey: "left")
//            actions.append(right)
//        }
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.EdgeLeft) || (contact.bodyA.categoryBitMask == PhysicsCategory.EdgeLeft && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
////            if topTouched == true {
////                let choose = [dino3moveDown, dino3moveRight]
////                dino3.run(choose.randomElement()!)
////            }
////            if groundTouched == true {
////                let choose = [dino3moveUp, dino3moveRight]
////                dino3.run(choose.randomElement()!)
////            }
////            if groundTouched == false && topTouched == false {
////                let choose = [dino3moveDown, dino3moveUp, dino3moveRight]
////                dino3.run(choose.randomElement()!)
////            }
////            edgeLeftTouched = true
////            let distance = sqrt(pow((self.size.width-player.position.x-32), 2.0) + pow((self.size.width-player.position.y-32), 2.0));
////            let go = distance/200
////            let acts = SKAction.sequence([SKAction.moveBy(x: self.size.width-player.position.x-32, y: 0, duration: go)])
////            let flip1 = SKAction.scaleX(to: CGFloat(-1), duration: 0.0001)
////            let gr = SKAction.group([acts, flip1])
//            actions.remove(at: actions.firstIndex(of: left)!)
//            dino3.removeAllActions()
//            dino3.run(actions.randomElement()!, withKey: "right")
//            actions.append(left)
//        }
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Top) || (contact.bodyA.categoryBitMask == PhysicsCategory.Top && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
////            if edgeLeftTouched == true {
////                let choose = [dino3moveDown, dino3moveRight]
////                dino3.run(choose.randomElement()!)
////            }
////            if edgeRightTouched == true {
////                let choose = [dino3moveDown, dino3moveLeft]
////                dino3.run(choose.randomElement()!)
////            }
////            if edgeLeftTouched == false && edgeRightTouched == false {
////                let choose = [dino3moveDown, dino3moveRight, dino3moveLeft]
////                dino3.run(choose.randomElement()!)
////            }
////            topTouched = true
//            actions.remove(at: actions.firstIndex(of: left)!)
//            dino3.removeAllActions()
//            dino3.run(actions.randomElement()!, withKey: "right")
//            actions.append(left)
//        }
//        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyB.categoryBitMask == PhysicsCategory.Ground) || (contact.bodyA.categoryBitMask == PhysicsCategory.Ground && contact.bodyB.categoryBitMask == PhysicsCategory.Dino3)) {
//            if edgeLeftTouched == true {
//                let choose = [dino3moveUp, dino3moveRight]
//                dino3.run(choose.randomElement()!)
//            }
//            if edgeRightTouched == true {
//                let choose = [dino3moveUp, dino3moveLeft]
//                dino3.run(choose.randomElement()!)
//            }
//            if edgeLeftTouched == false && edgeRightTouched == false {
//                let choose = [dino3moveUp, dino3moveRight, dino3moveLeft]
//                dino3.run(choose.randomElement()!)
//            }
//            groundTouched = true
//        }
    }
    
    func bite() {
        run(sound!)
    }
    func playDeath() {
        run(death!)
    }
    
    func addPhysics() {
//        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
//        block.physicsBody?.isDynamic = false
//        block.physicsBody?.affectedByGravity = false
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        
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
        
        dino3.physicsBody = SKPhysicsBody(circleOfRadius: (dino3.size.width-6)/2)
        dino3.physicsBody?.isDynamic = true
        dino3.physicsBody?.affectedByGravity = false
        dino3.physicsBody?.allowsRotation = false


    }
    func dino1stuff() {
        var rand = Double(Int.random(in: 1...3))
        dino1 = SKSpriteNode(imageNamed: "dino1")
        dino1.name = "dino1"
        
        let p = wtrBlocks.randomElement()!
        dino1.position = CGPoint(x: p.x, y: p.y+32)
        taken.append(CGPoint(x: p.x, y: p.y+32))
        dino1.zPosition = 1.0
        dino1.size = CGSize(width: standard.width, height: standard.height)
        dino1.xScale = CGFloat(1)
        addChild(dino1)
        showDino1 = true

        let dino1moveDown = SKAction.moveBy(x: 0, y: -576, duration: 3)
        let dino1moveUp = SKAction.moveBy(x: 0, y: 576, duration: 3)
        let dino1wait = SKAction.wait(forDuration: rand)
        let groupDino1 = SKAction.sequence([dino1moveUp, dino1moveDown, dino1wait])
        let dino1forever = SKAction.repeatForever(groupDino1)
        dino1.run(dino1forever)
        
        dino1.physicsBody = SKPhysicsBody(circleOfRadius: (dino1.size.width-6)/2)
        dino1.physicsBody?.affectedByGravity = false
        dino1.physicsBody?.allowsRotation = false
        
        dino1.physicsBody?.categoryBitMask = PhysicsCategory.Dino1
        dino1.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        dino1.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Rock
    }
    func dino2stuff() {
        var rand = Double(Int.random(in: 1...3))
        let randYPos = yPos.randomElement()
        //dino2
        dino2 = SKSpriteNode(imageNamed: "dino2")
        dino2.name = "dino2"
        dino2.position = CGPoint(x: xPos[xPos.count-1]+128, y: randYPos!)
        dino2.zPosition = 1.0
        dino2.size = CGSize(width: standard.width, height: standard.height)
        dino2.xScale = CGFloat(1)
        addChild(dino2)
        showDino2 = true
        
        let dino2moveRight = SKAction.moveBy(x: 1088, y: 0, duration: 5)
        let dino2moveLeft = SKAction.moveBy(x: -1088, y: 0, duration: 5)
        rand = Double(Int.random(in: 1...3))
        let dino2wait = SKAction.wait(forDuration: rand)
        let gr1 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(-1), duration: 0.1)])
        let gr2 = SKAction.group([dino2wait, SKAction.scaleX(to: CGFloat(1), duration: 0.1)])
        let groupDino2 = SKAction.sequence([dino2moveLeft, gr1, dino2moveRight, gr2])
        let dino2forever = SKAction.repeatForever(groupDino2)
        dino2.run(dino2forever)
        
        dino2.physicsBody = SKPhysicsBody(circleOfRadius: (dino2.size.width-6)/2)
        dino2.physicsBody?.isDynamic = true
        dino2.physicsBody?.affectedByGravity = false
        dino2.physicsBody?.allowsRotation = false
        
        dino2.physicsBody?.categoryBitMask = PhysicsCategory.Dino2
        dino2.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        dino2.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Rock
        
    }
    func dinos() {

        //dino1
        
        //dino3
        dino3 = SKSpriteNode(imageNamed: "dino3")
        dino3.name = "dino3"
        dino3.position = CGPoint(x: 32, y: yPos[yPos.count-1])
        dino3.zPosition = 1.0
        dino3.size = CGSize(width: standard.width, height: standard.height)
        dino3.xScale = CGFloat(1)
//        addChild(dino3)
        showDino3 = true
        
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
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.isDynamic = false
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.allowsRotation = false
        food.physicsBody?.categoryBitMask = PhysicsCategory.Food
        food.physicsBody?.collisionBitMask = 0
        food.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
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
        star.physicsBody = SKPhysicsBody(rectangleOf: star.size)
        star.physicsBody?.isDynamic = false
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.allowsRotation = false
        star.physicsBody?.categoryBitMask = PhysicsCategory.Star
        star.physicsBody?.collisionBitMask = 0
        star.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
        starShown = true
    }
    
    func throwRock(pos: CGPoint) {
        thrownRock = SKSpriteNode(imageNamed: "rock")
        thrownRock.name = "thrownRock"
        thrownRock.position = CGPoint(x: player.position.x, y: player.position.y)
        thrownRock.zPosition = 1.2
        thrownRock.size = CGSize(width: standard.width, height: standard.height)
        if rocks > 0 {
            addChild(thrownRock)
    
            //physics
            thrownRock.physicsBody = SKPhysicsBody(circleOfRadius: thrownRock.size.width/2)
            thrownRock.physicsBody?.isDynamic = true
            thrownRock.physicsBody?.affectedByGravity = false
            thrownRock.physicsBody?.allowsRotation = false
            thrownRock.physicsBody?.categoryBitMask = PhysicsCategory.Fire
            thrownRock.physicsBody?.collisionBitMask = 0
            thrownRock.physicsBody?.contactTestBitMask =  PhysicsCategory.Player
            thrownRock.physicsBody?.categoryBitMask = PhysicsCategory.Rock
            thrownRock.physicsBody?.collisionBitMask = PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
            thrownRock.physicsBody?.contactTestBitMask = PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
            
            
            if thrownRock.position.y < 0 || thrownRock.position.y > self.size.width || thrownRock.position.x < 0 || thrownRock.position.x > self.size.height  {
                thrownRock.removeFromParent()
            }
            
            let dt:CGFloat = 1.0/3
            let distance = CGVector(dx: pos.x-thrownRock.position.x, dy: pos.y-thrownRock.position.y)
            let velocity = CGVector(dx: (distance.dx)/dt, dy: (distance.dy)/dt)
//            let move = SKAction.moveBy(x: pos.x-thrownRock.position.x, y: pos.y-thrownRock.position.y, duration: 1)
//            thrownRock.run(move)
            thrownRock.physicsBody!.velocity=velocity
            rocks -= 1
        }

//        let groupDino4 = SKAction.sequence([dino4moveRight, dino4moveLeft, dino4wait])
    }
    
    func throwFire() {
        fire = SKSpriteNode(imageNamed: "fire")
        fire.name = "fire"
        fire.position = CGPoint(x: dino4.position.x+32, y: dino4.position.y)
        fire.zPosition = 1.2
        fire.size = CGSize(width: standard.width, height: standard.height)
        addChild(fire)
        
        //physics
        fire.physicsBody = SKPhysicsBody(circleOfRadius: fire.size.width/2)
        fire.physicsBody?.isDynamic = true
        fire.physicsBody?.affectedByGravity = false
        fire.physicsBody?.allowsRotation = false
        fire.physicsBody?.categoryBitMask = PhysicsCategory.Fire
        fire.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        fire.physicsBody?.contactTestBitMask =  PhysicsCategory.Player | PhysicsCategory.Rock
        
        
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
        player.size = CGSize(width: standard.width-6, height: standard.height-6)
        player.xScale = CGFloat(-1)
        player.position = CGPoint(x: standard.width/2, y: standard.height+32)
        taken.append(player.position)

        addChild(player)
    }
    
    func addBlock(imgName: String, pos: CGPoint) {
        if imgName == "water" {
            let water = SKSpriteNode(imageNamed: imgName)
            water.size = CGSize(width: standard.width, height: standard.height)
            water.zPosition = 1.1
            water.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: standard.width, height: standard.width/2))
            water.physicsBody?.affectedByGravity = false
            water.physicsBody?.allowsRotation = false
            water.physicsBody?.categoryBitMask = PhysicsCategory.Water
            water.physicsBody?.collisionBitMask = 0
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
        starLbl.text = "\(stars)"
        energyLbl.text = "\(level)"
        rockLbl.text = "\(rocks)"
        heartLbl.text = "\(health)"
        if level <= 0 && health <= 0 {
            level = 0
            health = 0
            gameOver()
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
        let form = timeFormatter(secs: timeCount)
        let timeString = timeStringFormatter(formatted: form)
        if timeCount >= 0 {
            guard let xFood = xPos.randomElement() else { return }
            guard let yFood = yPos.randomElement() else { return }
            guard let xStar = xPos.randomElement() else { return }
            guard let yStar = yPos.randomElement() else { return }

            if foodShown == false && taken.contains(CGPoint(x: xFood, y: yFood))==false && blockCount >= 10 {
                if reappear > 0 {
                    reappear -= 1
                }
                else {
                    showFood(pos: CGPoint(x: xFood, y: yFood))
                    taken.append(CGPoint(x: xFood, y: yFood))
                    foodShown = true
                }
            }
            if starShown == false && taken.contains(CGPoint(x: xStar, y: yStar))==false && blockCount >= 10 {
                showStar(pos: CGPoint(x: xStar, y: yStar))
                taken.append(CGPoint(x: xStar, y: yStar))
                starShown = true
            }
            
            if showDino1 == false {
                if dino1reappear > 0 {
                    dino1reappear -= 1
                    print(dino1reappear)
                }
                else {
                    dino1stuff()
                }
            }
            if showDino2 == false {
                if dino2reappear > 0 {
                    dino2reappear -= 1
                    print(dino2reappear)
                }
                else {
                    dino2stuff()
                }
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
            starLbl.fontColor = .white
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
            if timeCount%30==0 && rocks < 20 {
                rocks += 1
            }
            if level > 0 {
                level -= 1
            }
            if level == 0 && health > 0 {
                health -= 1
            }
            if level <= 0 && health <= 0 {
                gameOver()
            }
            
            if timeCount < 5 {
                lbl.fontColor = .white
                lbl.text = "Hello, Welcome to Maze Man!"
            }
            else {
                lbl.fontColor = .white
                lbl.text = "\(timeString)"
            }
            
            if timeCount%42==0 {
                lbl.fontColor = .white
                lbl.text = "Gravity time is very close!"
            }
            else if timeCount%43==0 {
                lbl.fontColor = .white
                lbl.text = "Gravity time is very close!"
            }
            else if timeCount%44==0 {
                lbl.fontColor = .white
                lbl.text = "Gravity time is very close!"
            }
            else if timeCount%45==0 {
                lbl.fontColor = .white
                lbl.text = "GRAVITY TIME!"
                player.physicsBody?.affectedByGravity = true
            }
            else {
                player.physicsBody?.affectedByGravity = false
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
