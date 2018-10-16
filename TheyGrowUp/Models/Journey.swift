//
//  Journey.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class Journey: TimeTrackable, Codable {
    
    // UUID
    // TODO: Sync with server
    private(set) var id: String = UUID().uuidString
    
    private let playerId: String
    
    internal let startTime = Date()
    internal var endTime = Date()
    
    typealias JourneySteps = [JourneyStep]
    private var steps = JourneySteps()
    
    private(set) var isFinished: Bool = false
    
    private(set) var intent: Int = 0
    
    private(set) var scoreKeeper = ScoreKeeper()
    
    init( playerId: String ) {
        self.playerId = playerId
    }
    
    func finish() {
        endTime = Date()
        isFinished = true
    }
    
    func changeIntent(by delta:Int) {
        intent += delta
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
        if !isFinished { steps.append(step) }
    }
    
    func addStep(with scene:Scene) {
        if !isFinished {
            let step = JourneyStep(baseScene: scene)
            
            // Set up our steps' relationships
            steps.last?.next = step
            step.previous = steps.last
            
            // Update our time tracking
            steps.last?.endTime = Date()
            endTime = Date()
            
            append(step)
        }
    }
    
    func setResponseForCurrentStep(_ choice: Int, with scene:Scene) {
        setResponse(choice, for: currentStep!, with: scene)
    }
    
    func setResponse(_ choice: Int, for step: JourneyStep, with scene:Scene) {
        currentStep?.response = choice
        
        // Update our ScoreKeeper
        scoreKeeper.changeScores( scene.choice(choice)!.scoreDeltas() )
        
        // Update our intent to vaccinate tracker
        changeIntent(by: scene.choice(choice)!.intent)
    }

    var length: Int {
        return steps.count
    }
    
    var currentStep: JourneyStep? {
        return steps.last
    }
    
}
