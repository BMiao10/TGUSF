//
//  Scene
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

class JourneyStep {
    
    // UUID set by server
    private var id: String?
    
    weak var previous: JourneyStep?
    var next: JourneyStep?
    
    let baseScene: Scene!
    
    // TODO Implement type checking
    var response: Int? {
        didSet {
            // update endTime
            endTime = Date()
        }
    }
    
    let startTime = Date()
    var endTime = Date()
    
    init( baseScene: Scene ){
        self.baseScene = baseScene
    }
    
}
