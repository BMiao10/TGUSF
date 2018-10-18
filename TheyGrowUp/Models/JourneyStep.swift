//
//  Scene
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class JourneyStep: TimeTrackable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case scenarioId
        case baseSceneId
        case startTime
        case endTime
    }
    
    // UUID
    // TODO: Sync with server
    private(set) var id: String = UUID().uuidString
    
    weak var previous: JourneyStep?
    weak var next: JourneyStep?
    
    let scenarioId: Scenario.Names
    let baseSceneId: Int
    
    // TODO Implement type checking
    var response: Int? {
        didSet {
            // update endTime
            endTime = Date()
        }
    }
    
    let startTime = Date()
    var endTime = Date()
    
    init( scenarioId: Scenario.Names, baseScene: Scene ){
        self.scenarioId = scenarioId
        self.baseSceneId = baseScene.id
    }
    
}
