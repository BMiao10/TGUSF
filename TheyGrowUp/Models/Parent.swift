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
import Disk

class Parent: Codable {
    
    // SINGLETON
    static private(set) var shared = Parent()
    
    static private let diskFilename = "parent.json"
    
    // UUID
    // TODO: Sync with server
    private(set) var id: String = UUID().uuidString
    
    // Timestamp when this parent-user was created
    private var createdAt = Date()
    
    // Location
    private var location: CLLocationCodable?
    
    // TODO: Registration info
    // private var registrationId: String?
    // private var registeredAt: Date?
    
    // Last played time
    private(set) var lastPlayed = Date()
    
    // Parent's child
    private(set) var child: Child?
    
    // Journeys
    private(set) var journeys: [Journey] = []
    
    private init() {
        updateLocation()
    }
    
    static func makeNewParent() {
        self.shared = Parent()
        try? Disk.remove(diskFilename, from: .applicationSupport)
    }
    
    public func updatePlaytime() {
        lastPlayed = Date()
    }
    
    public func updateLocation() {
        Locator.currentPosition(accuracy: .neighborhood, timeout: nil, onSuccess: { [weak self] location in
            print("Location found: \(location)")
            self?.location = CLLocationCodable(location: location.coordinate)
            }, onFail: { err, last in
                print("Failed to get location: \(err)")
        })
    }
    
    @discardableResult
    public func addChild( name: String, gender: Gender ) -> Child {
        let child = Child(parentId: id, name: name, gender: gender)
        self.child = child
        return child
    }
    
    @discardableResult
    public func addJourney() -> Journey {
        let journey = Journey(playerId: id)
        self.journeys.append(journey)
        updatePlaytime()
        return journey
    }
    
    public static func saveSharedToDisk () {
        guard self.shared.child != nil else {
            print("Unable to save incomplete status")
            return
        }
        
        do {
            try Disk.save(Parent.shared, to: .applicationSupport, as: diskFilename)
        } catch let error as NSError {
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        if Disk.exists("parent.json", in: .applicationSupport) {
            print("Successfully saved userData to '\(diskFilename)'")
        }
    }
    
    @discardableResult
    public static func loadSharedFromDisk () -> Bool {
        guard let data = try? Disk.retrieve(diskFilename, from: .applicationSupport, as: Parent.self) else {
            print("Unable to load data")
            return false
        }
        
        self.shared = data
        print("Loaded shared parent data from disk")
        return true
    }
    
}

struct CLLocationCodable: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(location: CLLocationCoordinate2D) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
