//
//  Parent.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class Parent {
    
    // UUID set by server
    private var id: String?
    
    // Timestamp where this parent-user was created
    private var createdAt: Date
    
    // TODO: Location
    // private var location
    
    // TODO: Registration info
    // private var registrationId: String?
    // private var registeredAt: Date?
    
    // Last played time
    private var lastPlayed: Date
    
    // Parent's child
    var child: Child?
    
    init() {
        createdAt = Date.init()
        lastPlayed = Date.init()
    }
    
    public func updatePlaytime() {
        lastPlayed = Date.init()
    }
    
}
