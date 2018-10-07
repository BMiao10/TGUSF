//
//  Gender.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/7/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

enum Gender {
    case male
    case female
    
    var diminutive: String {
        switch self {
        case .male:
            return "boy"
        case .female:
            return "girl"
        }
    }
    
    // TODO: Is this the best way to use this?
    var pronouns: [String] {
        switch self {
        case .male:
            return ["he", "him", "his"]
        case .female:
            return ["she", "her", "hers"]
        }
    }
}
