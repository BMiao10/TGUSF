//
//  GameViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 9/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

//https:\//www.youtube.com/watch?v=wuvn-vp5InE

import UIKit
import AVFoundation

struct myNode : Codable {
    var scene:String
    var animate:String
    var speaker:String
    var text:String
    var choiceA:String
    var choiceB:String
    var choiceC:String
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
        scene = try values.decode(String.self, forKey: .scene)
        animate = try values.decode(String.self, forKey: .animate)
        speaker = try values.decode(String.self, forKey: .speaker)
        text = try values.decode(String.self, forKey: .text)
        choiceA = try values.decode(String.self, forKey: .choiceA)
        choiceB = try values.decode(String.self, forKey: .choiceB)
        choiceC = try values.decode(String.self, forKey: .choiceC)
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

class GameViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!

    var wholeScene = [myNode]()
    var babyName = "Georgia"
    
    var choices = [Int]()
    var currScores = ["moneyScore":3,"timeScore":3,"healthScore":3,"communityScore":3]
    var currNode = 0
    
    @IBAction func choiceAButton(_ sender: Any) {
        if wholeScene[currNode].nextA > 0 {
            let prevNode = currNode
            currNode = wholeScene[prevNode].nextA
            loadScene(node: wholeScene[wholeScene[prevNode].nextA])
        }
        //TODO: store choice to export object
    }
    
    
    @IBAction func restartButton(_ sender: Any) {
        currNode = 0
        currScores = ["moneyScore":3,"timeScore":3,"healthScore":3,"communityScore":3]
        healthScore.image = UIImage(named:"good-health")
        timeScore.image = UIImage(named:"good-health")
        moneyScore.image = UIImage(named:"good-health")
        communityScore.image = UIImage(named:"good-health")
        loadScene(node:wholeScene[0])
    }
    
    @IBAction func choiceBButton(_ sender: Any) {
        if wholeScene[currNode].nextB > 0 {
            let prevNode = currNode
            currNode = wholeScene[prevNode].nextB
            loadScene(node: wholeScene[wholeScene[prevNode].nextB])
        }
        //TODO: store choice to export object
    }
    
    @IBAction func choiceCButton(_ sender: Any) {
        if wholeScene[currNode].nextC > 0 {
            let prevNode = currNode
            currNode = wholeScene[prevNode].nextC
            loadScene(node: wholeScene[wholeScene[prevNode].nextC])
        }
        //TODO: store choice to export object
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        //TODO:figure out moreInfo stuff
        moreInfoLabel.setTitle("Info not written yet", for: UIControlState.normal)
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
        wholeScene = loadSceneJSON(fileName:"scene1")!   //create nodes for each node
        
        super.viewDidLoad()
        
        //playSoundWith(fileName: "backgroundAudio", fileExtension: "mp3")
        
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.ageScaleLabel.text = "Month"
            self.ageLabel.text = "2"
        })
        
        //load first scene
        loadScene(node:wholeScene[currNode])
    }
    
    func loadSceneJSON(fileName: String) -> [myNode]? {

        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([myNode].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil

    }
    
    func loadScene(node:myNode) {
        //load background
        if node.scene.count > 0 && backgroundImage.image != UIImage(named: node.scene) {
            backgroundImage.image = UIImage(named: node.scene)
        }
        
        //TODO:add animations/audio
        let animations = node.animate.split(separator: ",")
        for i in animations {
            if i.contains("None") {
                break;
            }
            else if i.contains("Audio") {
                //play audio
                playSoundWith(fileName: String(i), fileExtension: "mp3")
            }
            else {
                //animate image
                //let imageArray = createImageArray(total:10, imagePrefix:String(i))
                //animateImage(imageView: textboxImage, images: imageArray, duration: 1.0, reps: 2)
                textboxImage.image = UIImage(named: String(i))
            }
            if i.contains("Info") {
                //add info button
                moreInfoLabel.setTitle("More Info", for: UIControlState.normal)
            }
            else {
                moreInfoLabel.setTitle("", for: UIControlState.normal)
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
        let scoreChange = ["timeScore":(timeScore,node.time), "healthScore":(healthScore,node.health), "moneyScore":(moneyScore,node.money), "communityScore":(communityScore,node.community)]
        let imagesArray = createImageArray(total:11,imagePrefix:"health")
        for i in scoreChange.keys {
            if scoreChange[i]?.1 != 0 {
                changeScore(changeImageName:i, change:(scoreChange[i]?.1)!, imageToChange: (scoreChange[i]?.0)!, imageArray: imagesArray)
            }
        }
        
        loadChoices(node: node)
    }
    
    //TODO:fix this
    func changeScore(changeImageName:String, change:Int, imageToChange:UIImageView, imageArray:[UIImage]) {
        var imagesArray = imageArray
        
        //get new score
        let currScore = currScores[changeImageName]
        let newScore = currScore! + change
         
        let changeScoreDict = [0, 3, 6, 10]
        
        if newScore < 1 {
            var tempImages = Array(imagesArray[0..<changeScoreDict[currScore!]])
            tempImages = tempImages.reversed()
            self.animateImage(imageView: imageToChange, images: tempImages, duration: 1, reps: 1)
            
            imageToChange.image = UIImage(named: "no-health")
            
            /**let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameOverViewController") as UIViewController
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
 **/
        }
        else if newScore > 3 {
            //TODO: animate gold star but no change in score
        }
        else {
            //animate change in score
            if change > 0 {
                let tempImages = Array(imagesArray[changeScoreDict[currScore!]..<changeScoreDict[newScore]])
                self.animateImage(imageView: imageToChange, images: tempImages, duration: 2, reps: 1)
                imageToChange.image = imagesArray[changeScoreDict[newScore]]
            }
            else {
                var tempImages = Array(imagesArray[changeScoreDict[newScore]..<changeScoreDict[currScore!]])
                tempImages = tempImages.reversed()
                self.animateImage(imageView: imageToChange, images: tempImages, duration: 1.5, reps: 1)
                imageToChange.image = imagesArray[changeScoreDict[newScore]]
            }
        }
        
        //update score
        currScores[changeImageName] = newScore
    }
    
    func loadChoices(node: myNode) {
        UIView.animate(withDuration: 1.7, delay: 0, animations: {
            if !node.choiceA.contains("None") {
                self.choiceALabel.setTitle(node.choiceA, for: UIControlState.normal)
            }
            else {
                self.choiceALabel.setTitle("", for: UIControlState.normal)
            }
        })   { (_) in
            
            UIView.animate(withDuration: 1.2, delay: 0, animations: {
                if !node.choiceB.contains("None") {
                    self.choiceBLabel.setTitle(node.choiceB, for: UIControlState.normal)
                }
                else {
                    self.choiceBLabel.setTitle("", for: UIControlState.normal)
                }
            })
            
            UIView.animate(withDuration: 1.2, delay: 0, animations: {
                if !node.choiceC.contains("None") {
                    self.choiceCLabel.setTitle(node.choiceC, for: UIControlState.normal)
                }
                else {
                    self.choiceCLabel.setTitle("", for: UIControlState.normal)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSoundWith(fileName: String, fileExtension: String) -> Void {
        let audioSourceURL:URL!
        audioSourceURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        
        if audioSourceURL == nil {
            print("This is not a valid song")
        }
        else {
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
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
