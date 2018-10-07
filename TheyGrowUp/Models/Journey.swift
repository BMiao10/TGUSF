//
//  Journey.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class Journey {
    
    // UUID set by server
    private var id: String?
    
    public let player: Parent
    
    private let startTime: Date
    private var endTime: Date
    
    typealias JourneySteps = [JourneyStep]
    private var steps = JourneySteps()
    
    var currentStep: JourneyStep? {
        guard let step = steps.last else {
            return nil
        }
        
        return step
    }
    
    private(set) var isFinished: Bool = false
    
    init( player: Parent ) {
        self.player = player
        self.startTime = Date()
        self.endTime = Date()
    }
    
    convenience init( player: Parent, steps: JourneySteps ) {
        self.init( player: player )
        self.steps = steps
    }
    
    func finish() {
        endTime = Date()
        isFinished = true
    }

}

extension Journey: Collection {
    
    // Required nested types, that tell Swift what our collection contains
    typealias Index = JourneySteps.Index
    typealias Element = JourneySteps.Element
    
    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return steps.startIndex }
    var endIndex: Index { return steps.endIndex }
    
    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get { return steps[index] }
    }
    
    // Method that returns the next index when iterating
    func index(after i: Journey.JourneySteps.Index) -> Journey.JourneySteps.Index {
        return steps.index(after: i)
    }
    
    func append(_ step:JourneyStep) {
        if !isFinished {
            steps.last?.next = step
            step.previous = steps.last
            endTime = Date()
            return steps.append(step)
        }
    }

    func length () -> Int {
        return steps.count
    }
    
}
