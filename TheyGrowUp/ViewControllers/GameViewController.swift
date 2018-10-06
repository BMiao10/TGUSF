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

class GameViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer!

    private var scenario = Scenario(fileName: "scenario1")
    var journey: Journey?
    private var journeyNode: JourneyNode?
    var child: Child?
    
    @IBOutlet weak var choiceALabel: UIButton!
    @IBOutlet weak var choiceBLabel: UIButton!
    @IBOutlet weak var choiceCLabel: UIButton!
    
    @IBOutlet weak var moreInfoLabel: UIButton!
    
    @IBOutlet weak var ageScaleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var scoreView: ScoreView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //playSoundWith(fileName: "backgroundAudio", fileExtension: "mp3")
        
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.ageScaleLabel.text = "Month"
            self.ageLabel.text = "2"
        })
       
        //load first scene
        loadScene( scenario.currentScene )
    }
    
    
    func loadScene(_ scene:Scene) {
        //load background
        backgroundImage.image = UIImage(named: scene.setting)
        
        // Play audio
        if let audioFile = scene.audio {
            playSoundWith(fileName: audioFile, fileExtension: "mp3")
        }
        
        // TODO: Add image animation
        
        //show speaker images
        textboxImage.image = UIImage(named: scene.speaker)
        
        //show dialogue
        textboxText.text = scene.text
        
        // More info
        if let moreInfo = scene.moreInfo {
            // TODO: Make this do something
            moreInfoLabel.setTitle("More Info", for: UIControl.State.normal)
            moreInfoLabel.isHidden = false
        } else {
            // Hide more info
            moreInfoLabel.setTitle("", for: UIControl.State.normal)
            moreInfoLabel.isHidden = true
        }
        
        // Change score with animations
        ScoreItems.allCases.forEach { (item) in
            if let currentScore = scoreView.score(for: item),
               let adjustment = scene.scoreDelta(for: item)
                {
                scoreView.setScore(score: currentScore + adjustment, for: item)
            }
        }
        
        // Update choices
        let choiceButtons = [choiceALabel, choiceBLabel, choiceCLabel]
        choiceButtons.forEach { (button) in
            button!.setTitle("", for: UIControl.State.normal)
        }
        for (index, choiceLabel) in scene.choices.enumerated() {
            choiceButtons[index]!.setTitle(choiceLabel, for: UIControl.State.normal)
        }
        
        let node = JourneyNode.init(baseScene: scenario.currentScene)
        journey?.append(node)
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
    
    // MARK: Button Actions
    @IBAction func choiceAButton(_ sender: Any) {
        switchSceneForChoice(0)
    }
    
    @IBAction func choiceBButton(_ sender: Any) {
        switchSceneForChoice(1)
    }
    
    @IBAction func choiceCButton(_ sender: Any) {
        switchSceneForChoice(2)
    }
    
    fileprivate func switchSceneForChoice(_ choice: Int) {
        let nextSceneId = scenario.currentScene.next[choice]
        journeyNode?.response = choice
        loadScene( scenario.advance(to: nextSceneId)! )
    }
    
    @IBAction func restartButton(_ sender: Any) {
        /*currNode = 0
        currScores = ["moneyScore":3,"timeScore":3,"healthScore":3,"communityScore":3]
        healthScore.image = UIImage(named:"good-health")
        timeScore.image = UIImage(named:"good-health")
        moneyScore.image = UIImage(named:"good-health")
        communityScore.image = UIImage(named:"good-health")
        loadScene(node:wholeScene[0])*/
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        //TODO:figure out moreInfo stuff
        moreInfoLabel.setTitle("Info not written yet", for: UIControl.State.normal)
    }

}
