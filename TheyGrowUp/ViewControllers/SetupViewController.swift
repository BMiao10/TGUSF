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
        
        // Position our modal off screen
        contentAreaTopConstraint.constant = self.view.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contentAreaTopConstraint.constant = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func prepareForSegue() {
        let babyName = self.nameTextField.text!
        Parent.shared.addChild(name: babyName, gender: gender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIntro" {
            prepareForSegue()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "showIntro":
            return isValidName()
        default:
            return true
        }
    }

}

extension SetupViewController: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(_ notification: Notification) {
        nextButton.isEnabled = isValidName()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidName() {
            nameTextField.resignFirstResponder()
            performSegue(withIdentifier: "showIntro", sender: self)
            return true
        } else {
            return false
        }
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
            
            self.contentAreaTopConstraint.constant = -1 * keyboardHeight + 40
            UIView.animate(withDuration: animationDuration!) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        self.contentAreaTopConstraint.constant = 0
        UIView.animate(withDuration: animationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
}
