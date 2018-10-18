//
//  Gender.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/7/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

public enum Gender: String, Codable {
    case male
    case female
    
    public enum Pronouns: String, Codable {
        case he, him, his, He, Him, His
    }
    
    public var diminutive: String {
        switch self {
        case .male:
            return "boy"
        case .female:
            return "girl"
        }
    }
    
    /// Returns a gender-specific pronoun
    /// - paramater: pronounType one of "he", "him", or "his"
    public func pronoun(_ pronounType: Pronouns) -> String {
        switch self {
        case .male:
            return pronounType.rawValue
        case .female:
            switch pronounType {
                case .he: return "she"
                case .him: return "her"
                case .his: return "her"
                case .He: return "She"
                case .Him: return "Her"
                case .His: return "Her"
            }
        }
    }
}
