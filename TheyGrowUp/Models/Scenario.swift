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
    
    enum Names: String, Codable {
        case pertussis
        case measles
        case kindergaren
        
        var fileName: String {
            return "scenario_" + self.rawValue
        }
        
        var next: Names? {
            switch self {
            case .pertussis:
                return .measles
            case .measles:
                return .kindergaren
            case .kindergaren:
                return nil
            }
        }
        
        var age: (number: Int, scale: String) {
            switch self {
            case .pertussis:
                return (2, "Months")
            case .measles:
                return (4, "Years")
            case .kindergaren:
                return (6, "Years")
            }
        }
    }
    
    private(set) var id: Names
    // Convenience naming
    var name: Names {
        return id
    }
    
    var scenes: [Int: Scene]!
    
    private var currentSceneId: Int
    var currentScene: Scene {
        return scenes[currentSceneId]!
    }

    private var previousSceneId: Int?
    var previousScene: Scene? {
        if let id = previousSceneId {
            return scenes[id]!
        } else {
            return nil
        }
    }
    
    private var firstSceneId: Int
    var firstScene: Scene {
        return scenes[firstSceneId]!
    }
    
    private var lastSceneId: Int
    var lastScene: Scene {
        return scenes[lastSceneId]!
    }
    var isAtStartOfScenario: Bool {
        return currentSceneId == firstSceneId
    }
    
    var isAtEndOfScenario: Bool {
        return currentScene.isLastScene
    }
    
    init( named scenario: Names ) throws {
        guard let url = Bundle.main.url(forResource: scenario.fileName, withExtension: "json") else {
            throw ScenarioError.FileUnavailable(fileName: scenario.fileName)
        }
            
        guard let data = try? Data(contentsOf: url),
              let jsonData = try? JSONDecoder().decode([Scene].self, from: data)
        else {
            throw ScenarioError.DataCorrupted(url: url)
        }
        
        self.id = scenario
        self.scenes = jsonData.reduce(into: [:]) { scenes, scene in
            scenes[ scene.id ] = scene
        }
        self.firstSceneId = jsonData.first!.id
        self.currentSceneId = jsonData.first!.id
        self.lastSceneId = jsonData.last!.id
    }
    
    mutating func advance( to scene:Scene ) {
        return advance(to: scene.id)
    }
    
    mutating func advance( to sceneId:Int ) {
        if sceneId == -1 {
            // TODO: End gameplay
            return
        } else if let validScene = scenes[ sceneId ] {
            previousSceneId = currentScene.id
            currentSceneId = validScene.id
        }
    }
    
    func nextScenario() -> Scenario.Names? {
        return id.next
    }
    
}
