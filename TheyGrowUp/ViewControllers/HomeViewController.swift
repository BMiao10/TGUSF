//
//  HomeViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 7/14/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    private var gender = Gender.male
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func boySwitch(_ sender: Any) {
        backgroundImage.image = UIImage(named: "homeBoy")
        gender = Gender.male
    }
    
    @IBAction func girlSwitch(_ sender: Any) {
        backgroundImage.image = UIImage(named: "homeGirl")
        gender = Gender.female
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check for existing data
        loadUserdata()
    }
    
    fileprivate func loadUserdata() {
        if Parent.loadSharedFromDisk()
            && Parent.shared.child != nil
            && Parent.shared.journeys.count > 0
            && Parent.shared.journeys.last!.isFinished == false
        {
            let alert = UIAlertController(title: "Continue play?", message: "Would you like to continue playing where you left off with your child \(Parent.shared.child!.name)?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: didChooseContinueAction(action:))
            let no = UIAlertAction(title: "No", style: .cancel, handler: didChooseContinueAction(action:))
            alert.addAction(yes)
            alert.addAction(no)
            alert.preferredAction = yes
            present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func didChooseContinueAction (action: UIAlertAction) {
        if action.title == "Yes" {
            // Configure controllers
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            vc.modalTransitionStyle = .partialCurl
            vc.shouldResumeJourney = true
            self.present(vc, animated: true, completion: nil)
        } else {
            Parent.makeNewParent()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSetupName" {
            let targetVC = segue.destination as! SetupViewController
            targetVC.gender = gender
        }
    }
}
