//
//  Scene
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class JourneyNode {
    
    // UUID set by server
    private var id: String?
    
    weak var previous: JourneyNode?
    var next: JourneyNode?
    
    let baseScene: Scene
    
    // TODO Implement type checking
    var response: Int? {
        didSet {
            // update endTime
            endTime = Date.init()
        }
    }
    
    let startTime: Date
    private var endTime: Date
    
    init( baseScene: Scene ){
        self.baseScene = baseScene
        self.startTime = Date.init()
        self.endTime = Date.init()
    }
    
}
