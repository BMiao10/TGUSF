//
//  ChildImages.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/16/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation


enum ChildImages: String {
    case baby
    case toddler
    case child
    
    static func forAge(number: Int, scale: String) -> ChildImages {
        switch scale.lowercased() {
        case "year", "years":
            return number >= 5 ? .child : .toddler
        default:
            return .baby
        }
    }
    
    func fileNameForGender(_ gender: Gender) -> String {
        // e.g. babyBoy or toddlerGirl
        return self.rawValue + gender.diminutive.capitalized
    }
}
