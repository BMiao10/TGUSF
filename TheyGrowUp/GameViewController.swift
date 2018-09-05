//
//  GameViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 9/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

struct myNode : Codable {
    var background:String
    var animate:String
    var speaker:String
    var text:String
    var choiceA:String
    var choiceB:String
    var nextA:Int
    var nextB:Int
    var money:Int
    var time:Int
    var health:Int
    var community:Int
    var intent:Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        background = try values.decode(String.self, forKey: .background)
        animate = try values.decode(String.self, forKey: .animate)
        speaker = try values.decode(String.self, forKey: .speaker)
        text = try values.decode(String.self, forKey: .text)
        choiceA = try values.decode(String.self, forKey: .choiceA)
        choiceB = try values.decode(String.self, forKey: .choiceB)
        nextA = try values.decode(Int.self, forKey: .nextA)
        nextB = try values.decode(Int.self, forKey: .nextB)
        money = try values.decode(Int.self, forKey: .money)
        time = try values.decode(Int.self, forKey: .time)
        health = try values.decode(Int.self, forKey: .health)
        community = try values.decode(Int.self, forKey: .community)
        intent = try values.decode(Int.self, forKey: .intent)
    }
}

struct ResponseData: Decodable {
    var nodes: [myNode]
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var ageScaleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var healthScore: UIImageView!
    @IBOutlet weak var timeScore: UIImageView!
    @IBOutlet weak var moneyScore: UIImageView!
    @IBOutlet weak var communityScore: UIImageView!
    
    override func viewDidLoad() {
        let scene = loadSceneJSON(filename:"scene1.json")   //create nodes for each node
        super.viewDidLoad()
        
        //TODO: change the baby age
        
        loadScene(node:scene![0])      //load first scene
    }
    
    func loadSceneJSON(filename fileName: String) -> [myNode]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.nodes
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadScene(node:myNode) {
        //load background
        if backgroundImage.image != UIImage(named: node.background) {
            backgroundImage.image = UIImage(named: node.background)
        }
        
        //add animations/audio
        let animations = node.animate.split(separator: ",")
        for i in animations {
            if i.contains("Audio") {
                //play audio
            }
            else if i.contains("Info") {
                //add info button
            }
            else {
                //animate
                let imageArray = createImageArray(total:10, imagePrefix:String(i))
                animateImage(imageView: textboxImage, images: imageArray, duration: 1.0, reps: 2)
            }
        }
        
        //show speaker images
        if textboxImage.image != UIImage(named: node.speaker) {
            textboxImage.image = UIImage(named: node.speaker)
        }
        
        //TODO: show dialogue
        
        //TODO: changeScore()
        
        //TODO: loadChoices()
    }
    
    func createNodes(content:String) {
        
    }
    
    //TODO: func changeScene() {
    //
    //}
    
    //TODO/PLACEHOLDER: choose next scene, given selection
    /** func selectChoice(choice:String, currNode:Int) -> Int {
        let nextChoice = Int
        
        if choice == "A" {
            nextChoice = 0
        }
        elif choice == "B" {
            nextChoice = 1
        }
        elif choice == "C" {
            nextChoice = 2
        }
        
        return nextChoice
    } **/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createImageArray(total:Int, imagePrefix:String) -> [UIImage] {
        var imageArray: [UIImage] = []
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)_\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func animateImage(imageView: UIImageView, images:[UIImage], duration:TimeInterval, reps:Int) {
        imageView.animationImages  = images
        imageView.animationDuration = duration
        imageView.animationRepeatCount = reps
        imageView.startAnimating()
    }

}
