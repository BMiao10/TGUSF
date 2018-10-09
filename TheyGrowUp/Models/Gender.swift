//
//  Gender.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/7/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

public enum Gender: String {
    case male
    case female
    
    public enum Pronouns: String {
        case he, him, his
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
                case .his: return "hers"
            }
        }
    }
}
