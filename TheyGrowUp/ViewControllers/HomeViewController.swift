//
//  HomeViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 7/14/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit
import AVFoundation

//initial home screen view
//allows customization of gender

class HomeViewController: UIViewController {

    private var gender = Gender.male
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let viewController:SetupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        viewController.gender = gender // propagate gender to next VC
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textbox: UIImageView!
    
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var scoreView: ScoreView!
    
    @IBOutlet weak var childAge: UIView!
    
    @IBOutlet weak var startBackground: UIImageView!
    
    @IBAction func boySwitch(_ sender: Any) {
        startBackground.image = UIImage(named: "boy_homeScreen")
        gender = Gender.male
        
    }
    
    @IBAction func girlSwitch(_ sender: Any) {
        startBackground.image = UIImage(named: "girl_homeScreen")
        gender = Gender.female
    }
    
    @IBAction func startButton(_ sender: Any) {
        // initialize background, animate scrolling effect
        startBackground.image = UIImage(named: "setupScreen")
        startBackground.frame = CGRect(x: 0, y: 0, width: 1330, height: 768)
        UIView.animate(withDuration: 1.4, delay: 0.5, animations: {
            self.startBackground.transform = CGAffineTransform(translationX: -307, y: 0)
        })   { (_) in
            //Initialize textboxText
            self.textboxText.text = "Congratulations! As the new parent of a healthy baby \(self.gender.diminutive), your task is to make the best choices to protect their health, as well as your own money, time, and community. \n\nYour progress will measured by the bars shown on the left. Good luck!"
            
            //animate text box
            //initialize baby age/ageScale
            UIView.animate(withDuration: 1.2, delay: 0.5, animations: {
                self.textbox.alpha = 1.0
                self.childAge.alpha = 1.0
                self.scoreView.alpha = 1.0
            })
            
            //animate text and image in textbox
            //TODO:add baby sound
            UIView.animate(withDuration: 1.1, delay: 1.8, animations: {
                if self.gender == Gender.male {
                    self.textboxImage.image = UIImage(named: "babyBoy")
                }
                else {
                    self.textboxImage.image = UIImage(named: "babyGirl")
                }
                
                self.textboxText.alpha = 1.0
                self.textboxImage.alpha = 1.0
            })
            
            //animate scoring bars
            self.scoreView.setProgress(for: .health, score: ScoreKeeper.maxScore)
            self.scoreView.setProgress(for: .money, score: ScoreKeeper.maxScore)
            self.scoreView.setProgress(for: .time, score: ScoreKeeper.maxScore)
            self.scoreView.setProgress(for: .community, score: ScoreKeeper.maxScore)
            
            // show next button
            UIView.animate(withDuration: 1.2, delay: 3.2, animations: {
                self.nextButton.alpha = 1
            })
             
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear all images and text until needed
        textboxText.alpha = 0
        textbox.alpha = 0.0
        
        nextButton.alpha = 0.0

        scoreView.alpha = 0.0
        childAge.alpha = 0.0
        textboxImage.alpha = 0.0
        
        // Set scoreView values to 0
        scoreView.setProgress(for: .health, score: 0)
        scoreView.setProgress(for: .money, score: 0)
        scoreView.setProgress(for: .time, score: 0)
        scoreView.setProgress(for: .community, score: 0)
    }
}
