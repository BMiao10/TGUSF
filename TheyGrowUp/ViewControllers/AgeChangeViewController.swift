//
//  AgeChangeViewController.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/16/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

class AgeChangeViewController: UIViewController {
    
    var ageNumber: Int = 1
    var ageScale: String = "Day"
    var child: Child!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func didContinue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        let fileName = ChildImages.forAge(number: ageNumber, scale: ageScale).fileNameForGender(child.gender)
        childImage.image = UIImage(named: fileName)
        
        nameLabel.text = child.name
        if child.gender == .male {
            nameLabel.textColor = UIColor(red:0.22, green:0.31, blue:0.56, alpha:1.0)
        } else {
            nameLabel.textColor =
                UIColor(red:0.86, green:0.24, blue:0.20, alpha:1.0)
        }
        
        var font = UIFont.systemFont(ofSize: 28)
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(red:0.23, green:0.31, blue:0.39, alpha:1.0),
            ]
        
        let baseText = NSMutableAttributedString(string: "Your baby \(child.gender.diminutive) has grown up! \(child.gender.pronoun(.He)) is now", attributes: attributes)
        
        font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        attributes[.font] = font
        let ageText = NSAttributedString(string: "\n\(ageNumber) \(ageScale) old!", attributes: attributes)
        
        baseText.append(ageText)
        textLabel.attributedText = baseText
    }

}
