//
//  JourneyNodeTemplate.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

struct Scene: Codable {
    
    let id: Int
    let setting: String
    private(set) var audio: String?
    let speaker: String?
    let image: String?
    private(set) var text: String
    private(set) var moreInfo: String?
    private(set) var choices: [SceneChoice]
    
    var isLastScene: Bool {
        return choices.isEmpty || choices.first?.next == -1
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case setting
        case audio
        case speaker
        case image
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
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.setting = try container.decode(String.self, forKey: .setting)
        self.audio = try? container.decode(String.self, forKey: .audio)
        self.speaker = try? container.decode(String.self, forKey: .speaker)
        self.image = try? container.decode(String.self, forKey: .image)
        self.text = try container.decode(String.self, forKey: .text)
        self.moreInfo = try? container.decode(String.self, forKey: .moreInfo)
        self.choices = try container.decode([SceneChoice].self, forKey:.choices)
        
        renderText()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(setting, forKey: .setting)
        try container.encode(audio, forKey: .audio)
        try container.encode(speaker, forKey: .speaker)
        try container.encode(image, forKey: .image)
        try container.encode(text, forKey: .text)
        try container.encode(moreInfo, forKey: .moreInfo)
        try container.encode(choices, forKey: .choices)
    }
    
    /// Called after scene initialized to render text elements
    mutating func renderText() {
        if let t = try? StringRenderService.render(text) {
            self.text = t
        }
        
        self.choices = choices.map {
            var mutableChoice = $0
            if let t = try? StringRenderService.render(mutableChoice.text) {
                mutableChoice.text = t
            }
            return mutableChoice
        }
    }
    
    func choice(_ index: Int) -> SceneChoice? {
        return index < choices.count ? choices[index] : nil
    }
    
}

struct SceneChoice: Codable {
    
    var text: String
    let next: Int
    let money: Int
    let time: Int
    let health: Int
    let community: Int
    let intent: Int
    
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
