//
//  SummaryViewController.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/16/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var subheading: UILabel!
    
    @IBOutlet weak var scoreView: ScoreView!
    
    @IBOutlet weak var healthText: UILabel!
    @IBOutlet weak var moneyText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var communityText: UILabel!
    @IBOutlet weak var viewFAQButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let journey = Parent.shared.journeys.last!
        
        subheading.text = try! StringRenderService.render(subheading.text!)
        
        healthText.text = try! StringRenderService.render(healthText.text!)
        moneyText.text = try! StringRenderService.render(moneyText.text!)
        timeText.text = try! StringRenderService.render(timeText.text!)
        communityText.text = try! StringRenderService.render(communityText.text!)
        
        // Sync up the scoreView
        scoreView.syncProgress(with: journey.scoreKeeper)
        scoreView.hideLabels(true, animated: false)
    }
    
    @IBAction func viewFAQ(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
