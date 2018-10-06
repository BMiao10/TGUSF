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
    
    typealias JourneyNodes = [JourneyNode]
    private var nodes = JourneyNodes()
    
    private(set) var isFinished: Bool = false
    
    init( player: Parent ) {
        self.player = player
        self.startTime = Date.init()
        self.endTime = Date.init()
    }
    
    convenience init( player: Parent, nodes: JourneyNodes ) {
        self.init( player: player )
        self.nodes = nodes
    }
    
    func finish () {
        endTime = Date.init()
        isFinished = true
    }
}

extension Journey: Collection {
    
    // Required nested types, that tell Swift what our collection contains
    typealias Index = JourneyNodes.Index
    typealias Element = JourneyNodes.Element
    
    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return nodes.startIndex }
    var endIndex: Index { return nodes.endIndex }
    
    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get { return nodes[index] }
    }
    
    // Method that returns the next index when iterating
    func index(after i: Journey.JourneyNodes.Index) -> Journey.JourneyNodes.Index {
        return nodes.index(after: i)
    }
    
    func append(_ node:JourneyNode) {
        if !isFinished {
            nodes.last?.next = node
            node.previous = nodes.last
            endTime = Date.init()
            return nodes.append(node)
        }
    }

    func length () -> Int {
        return nodes.count
    }
    
}
