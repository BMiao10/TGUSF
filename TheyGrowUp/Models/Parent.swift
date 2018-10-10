//
//  Parent.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

class Parent {
    
    // SINGLETON
    static let shared = Parent()
    
    // UUID set by server
    private var id: String
    
    // Timestamp where this parent-user was created
    private var createdAt: Date
    
    // TODO: Location
    private var location: CLLocationCoordinate2D?
    
    // TODO: Registration info
    // private var registrationId: String?
    // private var registeredAt: Date?
    
    // Last played time
    private(set) var lastPlayed: Date
    
    // Parent's child
    private(set) var child: Child?
    
    // Journeys
    private(set) var journeys: [Journey] = []
    
    private init() {
        // TODO: Sync with server
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.lastPlayed = Date()
        
        Locator.currentPosition(accuracy: .neighborhood, timeout: nil, onSuccess: { [weak self] location in
            print("Location found: \(location)")
            self?.location = location.coordinate
        }, onFail: { err, last in
            print("Failed to get location: \(err)")
        })
    }
    
    public func updatePlaytime() {
        lastPlayed = Date()
    }
    
    @discardableResult
    public func addChild( name: String, gender: Gender ) -> Child {
        let child = Child(parent: self, name: name, gender: gender)
        self.child = child
        return child
    }
    
    @discardableResult
    public func addJourney() -> Journey {
        let journey = Journey(player: self)
        self.journeys.append(journey)
        updatePlaytime()
        return journey
    }
    
}
