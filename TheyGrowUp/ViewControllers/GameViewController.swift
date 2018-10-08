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
    
    private weak var sceneAudioPlayer: AudioPlayer?

    private var scenario: Scenario!
    private weak var journey: Journey?
    
    @IBOutlet weak var choiceALabel: UIButton!
    @IBOutlet weak var choiceBLabel: UIButton!
    @IBOutlet weak var choiceCLabel: UIButton!
    private var choiceButtons: [UIButton]!
    
    @IBOutlet weak var moreInfoLabel: UIButton!
    
    @IBOutlet weak var ageScaleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var scoreView: ScoreView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        choiceButtons = [choiceALabel, choiceBLabel, choiceCLabel]
        
        // TODO: Refactor to separate view class?
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.ageScaleLabel.text = "Month"
            self.ageLabel.text = "2"
        })
       
        //load first scene
        Parent.shared.addJourney()
        scenario = Scenario(fileName: "scenario_pertussis")
        loadScene( scenario.currentScene )
    }
    
    
    fileprivate func loadScene(_ scene:Scene) {
        //load background
        backgroundImage.image = UIImage(named: scene.setting)
        
        // Stop old audio
        if let player = sceneAudioPlayer {
            AudioPlayerManager.remove(player: player)
            sceneAudioPlayer = nil
        }
        
        // Play new audio
        if let audioFile = scene.audio {
            sceneAudioPlayer = try? AudioPlayerManager.play(fileName: audioFile + ".mp3", discardOnCompletion: true)
        }
        
        // TODO: Add image animation
        
        //show speaker images
        textboxImage.image = UIImage(named: scene.speaker)
        
        //show dialogue
        textboxText.text = scene.text
        
        // More info
        if let moreInfo = scene.moreInfo {
            // TODO: Make this do something
            moreInfoLabel.setTitle("More Info", for: .normal)
            moreInfoLabel.isHidden = false
            journey?.changeIntent(by: 1)
        } else {
            // Hide more info
            moreInfoLabel.setTitle("", for: .normal)
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
        choiceButtons.forEach { (button) in
            button.setTitle("", for: .normal)
        }
        for (index, choiceLabel) in scene.choices.enumerated() {
            choiceButtons[index].setTitle(choiceLabel, for: .normal)
        }
        
        // Update our journey
        journey?.append( JourneyStep(baseScene: scenario.currentScene) )
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
        journey?.currentStep?.response = choice
        // TODO: Handle end of scenario
        loadScene( scenario.advance(to: nextSceneId)! )
    }
    
    @IBAction func restartButton(_ sender: Any) {
        // TODO: Reconnect restart button
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
        moreInfoLabel.setTitle("Info not written yet", for: .normal)
    }

}
