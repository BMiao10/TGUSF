//
//  SetupViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 9/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

//customize name of baby and introduce doctor character
class SetupViewController: UIViewController {
    
    public var gender: Gender = Gender.male
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func setupNameButton(_ sender: Any) {
        if self.nameTextField.text?.isEmpty ?? true {
            self.errorMessage.text = "Please type a name"
        } else {
            let babyName = self.nameTextField.text!
            let journey = Journey.init(player: Parent.init())
            let child = Child.init(parent: journey.player, name: babyName, gender: gender)
            
            let viewController:GameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            viewController.journey = journey
            viewController.child = child
            viewController.modalTransitionStyle = .partialCurl
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var nurseLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
