//
//  Child.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class Child: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case name
        case gender
    }
    
    // UUID
    // TODO: Sync with server
    private(set) var id: String = UUID().uuidString
    
    private let parentId: String
    
    // TODO: Ask for age
    //public let age: Int?
    
    public let name: String
    
    public let gender: Gender
    
    // TODO: Ask for vaccine status
    //public let vaccinesUTD: Bool?
    
    /*init( parent: Parent, age: Int, gender: Gender, vaccinesUTD: Bool) {
        self.parent = parent
        self.age = age
        self.gender = gender
        self.vaccinesUTD = vaccinesUTD
    }*/
    
    init( parentId: String, name: String, gender: Gender ) {
        self.parentId = parentId
        self.name = name
        self.gender = gender
    }
    
}
