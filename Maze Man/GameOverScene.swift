//
//  GameOverScene.swift
//  Maze Man
//
//  Created by Yabby Yimer Wolle on 4/16/22.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var button: UIButton!
    var f = [Int]()
    
    override func didMove(to view: SKView) {
        
        
    }
    
    @objc func buttonClicked(){
        
        print("Hello")
    }
    
    init(size: CGSize, score: Int, past: [Int], highScore: Bool){
        
        super.init(size: size)
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        let s = (highScore ? "New High Score!" : "Game Over...")
        let text = "\(s)"
        gameOverLabel.text = "\(text)"
        gameOverLabel.fontSize = 70
        
        let current = SKLabelNode(fontNamed: "Chalkduster")
        current.text = "Current Score: \(score)"
        current.fontSize = 40
        
        let prevScores = SKLabelNode(fontNamed: "Chalkduster")
        prevScores.text = "\(past)"
        prevScores.fontSize = 35
        
        let instruct = SKLabelNode(fontNamed: "Chalkduster")
        instruct.text = "Tap anywhere to play again!"
        instruct.fontColor = .green
        instruct.fontSize = 30
        
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*(7/12))
        current.position = CGPoint(x: self.size.width/2, y: self.size.height*(6/12))
        prevScores.position = CGPoint(x: self.size.width/2, y: self.size.height*(5/12))
        instruct.position = CGPoint(x: self.size.width/2, y: self.size.height*(3/12))
        self.addChild(prevScores)
        self.addChild(instruct)
        self.addChild(current)
        self.addChild(gameOverLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let fd = SKTransition.fade(with: .gray, duration: 1)
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        
    }
    

}
