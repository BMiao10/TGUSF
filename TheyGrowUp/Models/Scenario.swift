//
//  Scenario
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

struct Scenario {
    
    var scenes: [Scene] = []
    
    private(set) var currentScene: Scene = Scene()
    private(set) var currentIndex: Int = 0 {
        didSet (newIndex) {
            if newIndex >= scenes.count {
                currentIndex = scenes.count - 1
            }
        }
    }
    private(set) var previousScene: Scene?
    
    init( fileName: String ) {  
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {

            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode([Scene].self, from: data)
                self.scenes = jsonData
                self.currentScene = self.scenes[0]
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    mutating func advance( by steps:Int = 1 ) -> Scene? {
        return advance(to:(currentIndex + steps))
    }
    
    mutating func advance( to sceneIndex:Int ) -> Scene? {
        if sceneIndex == -1 {
            // TODO: End gameplay
            return nil
        } else if sceneIndex < scenes.count {
            previousScene = currentScene
            currentIndex = sceneIndex
            currentScene = scenes[ currentIndex ]
            return currentScene
        } else {
            return nil
        }
    }
    
}
