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
    private(set) var audio: String?
    let speaker: String
    private(set) var text: String
    private(set) var moreInfo: String?
    private(set) var choices: [String]
    let next: [Int]
    let health: Int
    let money: Int
    let time: Int
    let community: Int
    let intent: Int
    
    var isLastScene: Bool {
        return next.isEmpty || next.first == -1
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case setting
        case audio
        case speaker
        case text
        case moreInfo
        case choices
        case next
        case health
        case money
        case time
        case community
        case intent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UInt.self, forKey: .id)
        self.setting = try container.decode(String.self, forKey: .setting)
        self.audio = try? container.decode(String.self, forKey: .audio)
        self.speaker = try container.decode(String.self, forKey: .speaker)
        self.text = try container.decode(String.self, forKey: .text)
        self.moreInfo = try? container.decode(String.self, forKey: .moreInfo)
        self.choices = try container.decode([String].self, forKey:.choices)
        self.next = try container.decode([Int].self, forKey: .next)
        self.health = try container.decode(Int.self, forKey: .health)
        self.money = try container.decode(Int.self, forKey: .money)
        self.time = try container.decode(Int.self, forKey: .time)
        self.community = try container.decode(Int.self, forKey: .community)
        self.intent = try container.decode(Int.self, forKey: .intent)
        
        renderText()
    }
//
//    init( id: UInt, setting: String, audio: String, speaker: String, text: String, moreInfo: String, choices: [String], next: [Int], health: Int, money: Int, time: Int, community: Int, intent: Int ) {
//        self.id = id
//        self.setting = setting
//        self.audio = audio
//        self.speaker = speaker
//        self.text = text
//        self.moreInfo = moreInfo
//        self.choices = choices
//        self.next = next
//        self.health = health
//        self.money = money
//        self.time = time
//        self.community = community
//        self.intent = intent
//    }
    
    /// Called after scene initialized to render text elements
    mutating func renderText() {
        if let t = try? StringRenderService.render(text) {
            self.text = t
        }
        
        self.choices = choices.map {
            try! StringRenderService.render($0)
        }
    }
    
    func scoreDelta(for item:ScoreKeeper.ScoreItems) -> Int {
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
    
    func scoreDeltas() -> [ScoreKeeper.ScoreItems: Int] {
        var deltas = [ScoreKeeper.ScoreItems: Int]()
        ScoreKeeper.ScoreItems.allCases.forEach {
            let d = scoreDelta(for: $0)
            if d != 0 {
                deltas.updateValue(d, forKey: $0)
            }
        }
        return deltas
    }
    
}
