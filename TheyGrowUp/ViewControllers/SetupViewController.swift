//
//  SetupViewController.swift
//  TheyGrowUp
//
//  Created by Brenda Miao on 9/4/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

var babyName = ""

//customize name of baby and introduce doctor character
class SetupViewController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func setupNameButton(_ sender: Any) {
        if self.nameTextField.text?.isEmpty ?? true {
            self.errorMessage.text = "Please type a name"
        } else {
            babyName = self.nameTextField.text!
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as UIViewController
            viewController.modalTransitionStyle = .partialCurl
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var nurseLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
