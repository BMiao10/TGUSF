//
//  ScoreKeeper.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/8/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

public struct ScoreKeeper {
    
    static let maxScore = 3
    
    enum ScoreItems: String, CaseIterable {
        case health
        case money
        case time
        case community
    }

    private(set) var scores: [ScoreItems: Int] = [
        .health: maxScore,
        .money: maxScore,
        .time: maxScore,
        .community: maxScore
    ]

    func score(for item:ScoreItems) -> Int {
        return scores[ item ]!
    }
    
    mutating func setScore(score newScore: Int, for item:ScoreItems) {
        // Validate the new score
        guard 0...ScoreKeeper.maxScore ~= newScore else {
            print( "Tried to set invalid score of \(newScore) for ScoreItem \(item)")
            return
        }
        
        guard scores[ item ] != newScore else {
            print( "Tried to set duplicate score of \(newScore) for ScoreItem \(item)")
            return
        }
        
        let oldScore = scores[ item ]
        scores[ item ] = newScore
        scoreDidChange(scoreItem: item, oldScore: oldScore!, newScore: newScore)
    }
    
    mutating func setScores(_ newScores: [ScoreItems: Int]) {
        newScores.forEach { (key: ScoreItems, value: Int) in
            setScore(score: value, for: key)
        }
    }
    
    mutating func changeScore(by scoreDelta: Int, for item:ScoreItems) {
        let newScore = scores[item]! + scoreDelta
        setScore(score: newScore, for: item)
    }
    
    mutating func changeScores(_ newScores: [ScoreItems: Int]) {
        newScores.forEach { (item: ScoreItems, score: Int) in
            let newScore = scores[item]! + score
            setScore(score: newScore, for: item)
        }
    }
    
}

// Notifications
extension ScoreKeeper {
    
    static let ScoreDidChange = Notification.Name("ScoreDidChange")
    
    enum ScoreDidChangeNotificationKeys: String {
        case scoreItem, oldScore, newScore
    }
    
    fileprivate func scoreDidChange( scoreItem: ScoreItems, oldScore: Int, newScore: Int ) {
        
        let userInfo: [ScoreDidChangeNotificationKeys : Any] = [
            .scoreItem: scoreItem,
            .oldScore: oldScore,
            .newScore: newScore
        ]
        NotificationCenter.default.post(name: ScoreKeeper.ScoreDidChange, object: self, userInfo: userInfo)
    }
    
}
