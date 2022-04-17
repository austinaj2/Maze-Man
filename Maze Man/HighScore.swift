//
//  HighScore.swift
//  Maze Man
//
//  Created by Yabby Yimer Wolle on 4/16/22.
//

import Foundation

class HighScore: NSObject, NSCoding
{
    var score: Int
    
    init(score: Int){
        
        self.score = score
    }
    
    // used when saved (encoded) to user defaults
    func encode(with coder: NSCoder)
    {
        coder.encode(score, forKey: "score")
    }
    
    // used when read (decoded) from user defaults
    required init?(coder: NSCoder)
    {
//        score = coder.decodeObject(forKey: "name") as! String
        score = coder.decodeInteger(forKey: "score")
    }
}
