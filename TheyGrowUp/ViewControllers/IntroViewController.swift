//
//  IntroViewController.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/14/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {


    @IBOutlet weak var textbox: UIImageView!
    @IBOutlet weak var textboxImage: UIImageView!
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var childAge: UIView!
    @IBOutlet weak var scoreView: ScoreView!
    
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
        
        // Customize baby image
        let fileName = Parent.shared.child!.gender == .male ? "babyBoy" : "babyGirl"
        textboxImage.image = UIImage(named: fileName)
        
        // Customize text
        textboxText.text = try? StringRenderService.render(textboxText.text!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateMe()
    }
    
    func animateMe() {
        //animate text box
        //initialize baby age/ageScale
        UIView.animate(withDuration: 0.8, delay: 0, animations: {
            self.textbox.alpha = 1.0
            self.childAge.alpha = 1.0
            self.scoreView.alpha = 1.0
        })
        
        //animate text and image in textbox
        //TODO:add baby sound
        if Parent.shared.child!.gender == .male {
            self.textboxImage.image = UIImage(named: "babyBoy")
        } else {
            self.textboxImage.image = UIImage(named: "babyGirl")
        }
        UIView.animate(withDuration: 1.1, delay: 0.7, animations: {
            self.textboxText.alpha = 1.0
            self.textboxImage.alpha = 1.0
        })
        
        //animate scoring bars
        self.scoreView.setProgress(for: .health, score: ScoreKeeper.maxScore)
        self.scoreView.setProgress(for: .money, score: ScoreKeeper.maxScore)
        self.scoreView.setProgress(for: .time, score: ScoreKeeper.maxScore)
        self.scoreView.setProgress(for: .community, score: ScoreKeeper.maxScore)
        
        // show next button
        UIView.animate(withDuration: 0.5, delay: 2, animations: {
            self.nextButton.alpha = 1
        })
    }
}