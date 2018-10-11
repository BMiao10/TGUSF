//
//  FAQs.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 10/10/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

struct FAQs: Decodable {
    
    let intentType: Bool
    let questions: [String]
    let answers: [String]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case intentType
        case questions
        case answers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.intentType = try container.decode(Bool.self, forKey: .intentType)
        self.questions = try container.decode([String].self, forKey: .questions)
        self.answers = try container.decode([String].self, forKey: .answers)
    }
}
