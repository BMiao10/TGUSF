//
//  Child.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class Child {
    
    // UUID set by server
    private var id: String?
    
    public let parent: Parent
    
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
    
    init( parent: Parent, name: String, gender: Gender ) {
        self.parent = parent
        self.name = name
        self.gender = gender
    }
    
}
