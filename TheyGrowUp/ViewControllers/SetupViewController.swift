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
        if self.nameTextField.text?.isEmpty == true {
            self.errorMessage.text = "Please type a name"
        } else {
            let babyName = self.nameTextField.text!
            Parent.shared.addChild(name: babyName, gender: gender)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            vc.modalTransitionStyle = .partialCurl
            self.present(vc, animated: true, completion: nil)
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
