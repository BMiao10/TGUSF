//
//  MoreInfoViewController.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/16/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    var content: String?
    
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 565, height: 384)
        
        mainText.text = content
    }
    
    @IBAction func didChooseClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
