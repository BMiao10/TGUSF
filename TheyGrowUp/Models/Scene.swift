//
//  JourneyNodeTemplate.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

struct Scene: Decodable {
    
    let id: UInt
    let setting: String
    var audio: String?
    let speaker: String
    let text: String
    var moreInfo: String?
    let choices: [String]
    let next: [Int]
    let health: Int
    let money: Int
    let time: Int
    let community: Int
    let intent: Int
    
    /*init( id: Int, setting: String, animate: String, speaker: String, text: String, choices: [String], next: [Int], money: Int, time: Int, health: Int, community: Int, intent: Int ) {
        self.id = id
        setting = setting
        self.animate = animate
        self.speaker = speaker
        self.text = text
        self.choices = choices
        self.next = next
        self.money = money
        self.time = time
        self.health = health
        self.community = community
        self.intent = intent
    }*/
    
    init() {
        self.id = 0
        self.setting = ""
        self.speaker = ""
        self.text = ""
        self.choices = []
        self.next = []
        self.health = 0
        self.money = 0
        self.time = 0
        self.community = 0
        self.intent = 0
    }
    
    func scoreDelta(for item:ScoreItems) -> Int? {
        switch item {
        case .health:
            return health
        case .money:
            return money
        case .time:
            return time
        case .community:
            return community
        }
    }
    
}
