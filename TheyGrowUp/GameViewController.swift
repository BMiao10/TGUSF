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
    var nextC:Int
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
        nextC = try values.decode(Int.self, forKey: .nextC)
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
    
    var scene = [myNode]()
    
    var choices = [Int]()
    var currScores = ["moneyScore":3,"timeScore":3,"healthScore":3,"communityScore":3]
    var currNode = 0
    
    @IBAction func choiceAButton(_ sender: Any) {
        let prevNode = currNode
        currNode = scene[prevNode].nextA
        loadScene(node: scene[scene[prevNode].nextA])
        //TODO: store choice to export object
    }
    
    
    @IBAction func choiceBButton(_ sender: Any) {
        let prevNode = currNode
        currNode = scene[prevNode].nextB
        loadScene(node: scene[scene[prevNode].nextB])
        //TODO: store choice to export object
    }
    
    @IBAction func choiceCButton(_ sender: Any) {
        let prevNode = currNode
        currNode = scene[prevNode].nextC
        loadScene(node: scene[scene[prevNode].nextC])
        //TODO: store choice to export object
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        //TODO:figure out moreInfo stuff
    }
    
    @IBOutlet weak var choiceALabel: UIButton!
    @IBOutlet weak var choiceBLabel: UIButton!
    @IBOutlet weak var choiceCLabel: UIButton!
    
    @IBOutlet weak var moreInfoLabel: UIButton!
    
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
        scene = loadSceneJSON(filename:"scene1.json")!   //create nodes for each node
        
        super.viewDidLoad()
        
        //TODO: animate change the baby age
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.ageScaleLabel.text = "🎉"
            self.ageLabel.text = "🎉"
            self.ageScaleLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.ageLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
        })   { (_) in
            
            UIView.animate(withDuration: 1.2, delay: 0, animations: {
                self.ageScaleLabel.text = "10"
                self.ageScaleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
        //load first scene
        loadScene(node:scene[currNode])
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
        if node.background.count > 0 && backgroundImage.image != UIImage(named: node.background) {
            backgroundImage.image = UIImage(named: node.background)
        }
        
        //TODO:add animations/audio
        let animations = node.animate.split(separator: ",")
        for i in animations {
            if i.contains("Audio") {
                //play audio
            }
            else if i.contains("Info") {
                //add info button
            }
            else {
                //animate image
                let imageArray = createImageArray(total:10, imagePrefix:String(i))
                animateImage(imageView: textboxImage, images: imageArray, duration: 1.0, reps: 2)
            }
        }
        
        //show speaker images
        if node.speaker.count > 0 && textboxImage.image != UIImage(named: node.speaker) {
            textboxImage.image = UIImage(named: node.speaker)
        }
        
        //show dialogue
        if node.text.count > 0 {
            textboxText.text = node.text
        }
        
        //change score with animations
        let scores = [node.time:"timeScore", node.health:"healthScore", node.money:"moneyScore", node.community:"communityScore"]
        let imagesArray = createImageArray(total:11,imagePrefix:"health")
        for i in scores.keys {
            if i != 0 {
                changeScore(changeImage:scores[i]!, change:i, imageArray: imagesArray)
            }
        }
        
        loadChoices()
    }
    
    //TODO:fix this
    func changeScore(changeImage:String, change:Int, imageArray:[UIImage]) {
        /**
        let currImage = UIImage(named: changeImage) //get current metric image to change
         
        //get new score
        let currScore = currScores[changeImage]
        let newScore = currScore! + change
         
        let changeScoreDict = [0, 3, 6, 10]
        
        if newScore < 1 {
            //TODO: animate loss of score and change to end screen
            self.animateImage(imageView: currImage, images: imageArray[changeScoreDict[currScore]..<imageArray.count].reverse(), duration: 1, reps: 1)
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameOverViewController") as UIViewController
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }
        else if newScore > 3 {
            //TODO: animate gold star but no change in score
        }
        else {
            //animate change in score
            if change > 0 {
                self.animateImage(imageView: currImage, images: imageArray[changeScoreDict[currScore]..<changeScoreDict[newScore]], duration: 1, reps: 1)
            }
            else {
                self.animateImage(imageView: currImage, images: imageArray[changeScoreDict[currScore]..<changeScoreDict[newScore]].reverse(), duration: 1, reps: 1)
            }
            
        }
        
        //update score
        currScores[changeImage] = newScore
 **/
    }
    
    //TODO: finish this
    func loadChoices() {
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.choiceALabel.setTitle("", for: UIControlState.normal)
        })   { (_) in
            
            UIView.animate(withDuration: 1.2, delay: 0, animations: {
                self.choiceBLabel.setTitle("", for: UIControlState.normal)
            })
            
            UIView.animate(withDuration: 1.2, delay: 0, animations: {
                self.choiceCLabel.setTitle("", for: UIControlState.normal)
            })
        }
    }

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
