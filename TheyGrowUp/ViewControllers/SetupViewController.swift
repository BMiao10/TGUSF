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
    
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var nurseText: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var contentAreaTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        // Customize baby image
        let fileName = gender == .male ? "babyBoy" : "babyGirl"
        babyImage.image = UIImage(named: fileName)
        
        // Customize text
        let dict = ["Child.gender": gender.diminutive]
        nurseText.text = try? StringRenderService.render(nurseText.text!, data: dict)
        
        // Register observers
        nameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nameTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func didChooseBackButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didChooseNextButton(_ sender: Any) {
        advanceToGame()
    }
    
    private func advanceToGame() {
        if self.nameTextField.text?.isEmpty == true {
            self.errorMessage.text = "Please type a name"
        } else {
            nameTextField.resignFirstResponder()
            
            let babyName = self.nameTextField.text!
            Parent.shared.addChild(name: babyName, gender: gender)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            vc.modalTransitionStyle = .partialCurl
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

extension SetupViewController: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(_ notification: Notification) {
        nextButton.isEnabled = isValidName()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidName() {
            advanceToGame()
        }
        
        nameTextField.resignFirstResponder()
        return true
    }
    
    private func isValidName() -> Bool {
        if let text = nameTextField.text {
            return text.count >= 2
        } else {
            return false
        }
    }
}

// Keyboard handler
extension SetupViewController {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            
            UIView.animate(withDuration: animationDuration!) {
                self.contentAreaTopConstraint.constant = -1 * keyboardHeight + 40
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        UIView.animate(withDuration: animationDuration!) {
            self.contentAreaTopConstraint.constant = 0
        }
    }
}
