//
//  Scenario
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

struct Scenario {
    
    enum ScenarioError: Error {
        case FileUnavailable(fileName: String)
        case DataCorrupted(url: URL)
    }
    
    enum Names: String {
        case pertussis
        
        var fileName: String {
            return "scenario_" + self.rawValue
        }
    }
    
    private(set) var id: String!
    
    var scenes: [Int: Scene]!
    
    private(set) var currentScene: Scene!
    private(set) var previousScene: Scene?
    
    init( named scenario: Names ) throws {
        guard let url = Bundle.main.url(forResource: scenario.fileName, withExtension: "json") else {
            throw ScenarioError.FileUnavailable(fileName: scenario.fileName)
        }
            
        guard let data = try? Data(contentsOf: url),
              let jsonData = try? JSONDecoder().decode([Scene].self, from: data)
        else {
            throw ScenarioError.DataCorrupted(url: url)
        }
        
        self.id = scenario.fileName
        self.scenes = jsonData.reduce(into: [:]) { scenes, scene in
            scenes[ scene.id ] = scene
        }
        self.currentScene = jsonData[0]
    }
    
    mutating func advance( to scene:Scene ) {
        return advance(to: scene.id)
    }
    
    mutating func advance( to sceneId:Int ) {
        if sceneId == -1 {
            // TODO: End gameplay
            return
        } else if let validScene = scenes[ sceneId ] {
            previousScene = currentScene
            currentScene = validScene
        }
    }
    
}
