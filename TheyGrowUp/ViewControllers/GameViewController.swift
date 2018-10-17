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
import PMSuperButton

class GameViewController: UIViewController {
    
    private weak var sceneAudioPlayer: AudioPlayer?

    // This can be set by presenting view controller to alter which scenario is loaded
    var scenarioName: Scenario.Names = .pertussis
    private var scenario: Scenario!
    private weak var journey: Journey?
    
    public var shouldResumeJourney: Bool = false
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var childAge: ChildAgeView!
    
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var choiceA: PMSuperButton!
    @IBOutlet weak var choiceB: PMSuperButton!
    @IBOutlet weak var choiceC: PMSuperButton!
    private var choiceButtons: [UIButton]!
    
    @IBOutlet weak var moreInfo: PMSuperButton!
    
    @IBOutlet weak var scoreView: ScoreView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        choiceButtons = [choiceA, choiceB, choiceC]

        // TODO: Handle any load errors gracefully
        scenario = try! Scenario(named: scenarioName)
        
        // Load child age info
        let age = scenario.id.age
        childAge.ageNumber = age.number
        childAge.ageScale = age.scale
        childAge.gender = Parent.shared.child!.gender
        
        if shouldResumeJourney {
            // Load scene where user left off
            journey = Parent.shared.journeys.last
            scenario.advance(to: journey!.currentStep!.baseSceneId)
            
            // Load up the scoreView
            scoreView.syncProgress(with: journey!.scoreKeeper)
            
            // Load up where we left off
            loadScene( scenario.currentScene, addToJourney: false )
        } else {
            // Create new journey and will load first scene
            journey = Parent.shared.addJourney()
            loadScene( scenario.currentScene )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scoreView.hideLabels(true, animated: animated)
    }
    
    
    fileprivate func loadScene(_ scene:Scene, addToJourney: Bool = true) {
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
        
        // Show speaker images
        if let speaker = scene.speaker,
            let validSpeaker = UIImage(named: speaker) {
            speakerImage.image = validSpeaker
            speakerImage.isHidden = false
        } else {
            speakerImage.image = nil
            speakerImage.isHidden = true
        }
        
        // Show text image
        if let sceneImage = scene.image,
            let validImage = UIImage(named: sceneImage) {
            textboxImage.image = validImage
            textboxImage.isHidden = false
        } else {
            textboxImage.image = nil
            textboxImage.isHidden = true
        }
        
        //show dialogue
        textboxText.text = scene.text
        
        // More info
        if let moreInfoText = scene.moreInfo {
            // TODO: Make this do something
            moreInfo.isHidden = false
        } else {
            // Hide more info
            moreInfo.isHidden = true
        }
        
        // Update choices
        for (index, button) in choiceButtons.enumerated() {
            if let choiceText = scene.choice(index)?.text {
                button.setTitle(choiceText, for: .normal)
                button.isHidden = false
            } else {
                button.setTitle("", for: .normal)
                button.isHidden = true
            }
        }
        
        // Sync our score view
        scoreView.syncProgress(with: journey!.scoreKeeper)
        
        // Update our journey
        if addToJourney {
            journey?.addStep(with: scenario.currentScene)
        }
        
        // If this is the first scene for a new scenario, show the age change modal
        if scenario.id != .pertussis && scenario.isAtStartOfScenario {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AgeChangeViewController") as! AgeChangeViewController
            vc.ageNumber = scenario.id.age.number
            vc.ageScale = scenario.id.age.scale.lowercased()
            vc.child = Parent.shared.child!
            present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: Button Actions
    @IBAction func didMakeChoice(_ sender: Any) {
        let index = choiceButtons.firstIndex(of: sender as! UIButton)
        switchSceneForChoice(index!)
    }
    
    fileprivate func switchSceneForChoice(_ choice: Int) {
        journey?.setResponseForCurrentStep(choice, with: scenario.currentScene)
        
        if scenario.isAtEndOfScenario {
            // TODO: Handle end of scenario -> GOTO FAQs
            print("Scenario \(scenario.id) ended")
            Parent.shared.updatePlaytime()
            
            if let next = scenario.nextScenario() {
                scenario = try! Scenario.init(named: next)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                    self.loadScene( self.scenario.currentScene )
                }
            } else {
                journey?.finish()
                // Advance to summary screen
                showFAQs()
            }
        } else {
            let nextSceneId = scenario.currentScene.choices[choice].next
            scenario.advance(to: nextSceneId)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.loadScene( self.scenario.currentScene )
            }
        }
    }
    
    fileprivate func prepareForRestart() {
        // TODO: Hide this button in release version
        print("Scenario restarting")
        journey?.finish()
        Parent.shared.updatePlaytime()
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        //TODO:figure out moreInfo stuff
        journey?.changeIntent(by: 1)
    }
    
    
    @IBAction func testShowFAQs(_ sender: Any) {
        showFAQs()
    }
    
    fileprivate func showFAQs () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restartGame" {
            prepareForRestart()
        }
    }

}
