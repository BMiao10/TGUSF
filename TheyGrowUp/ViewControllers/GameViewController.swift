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
    @IBOutlet var moreInfoView: UIView!
    
    @IBOutlet weak var moreInfoContent: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        choiceButtons = [choiceALabel, choiceBLabel, choiceCLabel]
        
        // TODO: Refactor to separate view class?
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.ageScaleLabel.text = "Month"
            self.ageLabel.text = "2"
        })
       
        //load first scene
        journey = Parent.shared.addJourney()
        // TODO: Handle any load errors gracefully
        scenario = try! Scenario(fileName: "scenario_pertussis")
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
        journey?.currentStep?.response = choice
        
        if scenario.currentScene.isLastScene {
            // TODO: Handle end of scenario -> GOTO FAQs
            print("Scenario ended")
            journey?.finish()
            Parent.shared.updatePlaytime()
            
        } else {
            let nextSceneId = scenario.currentScene.next[choice]
            loadScene( scenario.advance(to: nextSceneId)! )
        }
    }
    
    @IBAction func restartButton(_ sender: Any) {
        // TODO: Hide this button in release version
        print("Scenario restarting")
        journey?.finish()
        Parent.shared.updatePlaytime()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as! ViewController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        moreInfoContent.text = scenario.currentScene.moreInfo
        self.view.addSubview(moreInfoView)
    }
    
    @IBAction func closeMoreInfo(_ sender: Any) {
        self.moreInfoView.removeFromSuperview()
    }
    
}
