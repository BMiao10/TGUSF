//
//  ViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 7/14/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit
import AVFoundation

var gender = "boy"
var initScore :[UIImage] = []

//initial home screen view
//allows customization of gender

class ViewController: UIViewController {

    
    @IBAction func nextButtonAction(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupViewController") as UIViewController
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textbox: UIImageView!
    
    @IBOutlet weak var textboxText: UILabel!
    @IBOutlet weak var textboxImage: UIImageView!
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    
    @IBOutlet weak var healthScore: UIImageView!
    @IBOutlet weak var moneyScore: UIImageView!
    @IBOutlet weak var timeScore: UIImageView!
    @IBOutlet weak var communityScore: UIImageView!
    
    @IBOutlet weak var healthIcon: UIImageView!
    @IBOutlet weak var moneyIcon: UIImageView!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var communityIcon: UIImageView!
    
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageScaleLabel: UILabel!
    
    @IBOutlet weak var startBackground: UIImageView!
    
    @IBAction func boySwitch(_ sender: Any) {
        startBackground.image = UIImage(named: "boy_homeScreen")
        gender = "boy"
    }
    
    @IBAction func girlSwitch(_ sender: Any) {
        startBackground.image = UIImage(named: "girl_homeScreen")
        gender = "girl"
    }
    
    @IBAction func startButton(_ sender: Any) {
        // initialize background, animate scrolling effect
        startBackground.image = UIImage(named: "setupScreen")
        startBackground.frame = CGRect(x: 0, y: 0, width: 1330, height: 768)
        UIView.animate(withDuration: 1.7, delay: 0.5, animations: {
            self.startBackground.transform = CGAffineTransform(translationX: -307, y: 0)
        })   { (_) in
            //Initialize textboxText
            self.textboxText.text = "Congratulations! As the new parent of a healthy baby " + gender + ", your task is to make the best choices to protect their health, as well as your own money, time, and community. \n\nYour progress will measured by the bars shown on the right. Good luck!"
            
            //animate text box
            //initialize baby age/ageScale
            UIView.animate(withDuration: 1.2, delay: 0.5, animations: {
                self.textbox.alpha = 1.0
                self.babyImage.alpha = 1.0
            })
            
            //animate text and image in textbox
            //TODO:add baby sound
            UIView.animate(withDuration: 1.2, delay: 1.8, animations: {
                if gender == "boy" {
                    self.textboxImage.image = UIImage(named: "babyBoy")
                }
                else {
                    self.textboxImage.image = UIImage(named: "babyGirl")
                }
                
                self.textboxText.alpha = 1.0
                self.textboxImage.alpha = 1.0
                
                self.ageLabel.alpha = 1.0
                self.ageScaleLabel.alpha = 1.0

                
            })
            
            //initialize icons
            UIView.animate(withDuration: 1.2, delay: 2, animations: {
                self.healthIcon.alpha = 1
                self.moneyIcon.alpha = 1
                self.timeIcon.alpha = 1
                self.communityIcon.alpha = 1
            })
            
            
            //animate scoring bars
            UIView.animate(withDuration: 1.2, delay: 2, animations: {
                self.healthScore.alpha = 1
                self.moneyScore.alpha = 1
                self.timeScore.alpha = 1
                self.communityScore.alpha = 1
                
                self.animateImage(imageView: self.healthScore, images: initScore, duration: 2, reps: 2)
                self.animateImage(imageView: self.moneyScore, images: initScore, duration: 2, reps: 2)
                self.animateImage(imageView: self.timeScore, images: initScore, duration: 2, reps: 2)
                self.animateImage(imageView: self.communityScore, images: initScore, duration: 2, reps: 2)
            
            })

            //initialize scoring labels
            UIView.animate(withDuration: 1.2, delay: 2, animations: {
                self.healthLabel.alpha = 1
                self.moneyLabel.alpha = 1
                self.timeLabel.alpha = 1
                self.communityLabel.alpha = 1
            })
            
            // show next button
            UIView.animate(withDuration: 1.2, delay: 3.2, animations: {
                self.nextButton.alpha = 1
            })
             
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: start playing music
        
        //clear all images and text until needed
        healthLabel.alpha = 0
        moneyLabel.alpha = 0
        timeLabel.alpha = 0
        communityLabel.alpha = 0
        
        ageLabel.alpha = 0
        ageScaleLabel.alpha = 0
    
        textboxText.alpha = 0
        
        textbox.alpha = 0.0
        
        healthLabel.alpha = 0.0
        moneyLabel.alpha = 0.0
        timeLabel.alpha = 0.0
        communityLabel.alpha = 0.0
        
        nextButton.alpha = 0.0

        healthIcon.alpha = 0.0
        moneyIcon.alpha = 0.0
        timeIcon.alpha = 0.0
        communityIcon.alpha = 0.0
        
        healthScore.alpha = 0.0
        moneyScore.alpha = 0.0
        timeScore.alpha = 0.0
        communityScore.alpha = 0.0

        babyImage.alpha = 0.0
        textboxImage.alpha = 0.0
        
        //initialize animations
        initScore = createImageArray(total:11,imagePrefix:"health")
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
