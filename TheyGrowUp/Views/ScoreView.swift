//
//  ScoreView.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

@IBDesignable
class ScoreView: UIView {
    
    @IBOutlet var view: UIView!
    private var contentView: UIView?

    @IBOutlet weak var healthScore: LinearProgressBar!
    @IBOutlet weak var moneyScore: LinearProgressBar!
    @IBOutlet weak var timeScore: LinearProgressBar!
    @IBOutlet weak var communityScore: LinearProgressBar!
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    
    
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard
            let views = bundle.loadNibNamed("ScoreView", owner: self, options: nil),
            let contentView = views.first as? UIView
        else {
            return nil
        }
        
        return contentView
    }
    
    func xibSetup() {
        // Load in the xib and add it to our view
        let xib = self.loadNib()!
        self.addSubview(xib)
        xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xib.frame = self.bounds
        contentView = xib
        
        // Set up colors
        ScoreKeeper.ScoreItems.allCases.forEach { (item) in
            let bar = scoreBar(for: item)
            bar.barColorForValue = { value in
                switch value {
                case 0..<34:
                    return UIColor.init(hue: 357.0 / 360.0, saturation: 0.57, brightness: 0.93, alpha: 1)
                case 34..<67:
                    return UIColor.init(hue: 46.0 / 360.0, saturation: 0.54, brightness: 0.93, alpha: 1)
                default:
                    return UIColor.init(hue: 163.0 / 360.0, saturation: 0.68, brightness: 0.67, alpha: 1)
                }
            }
        }
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleScoreDidChange(_:)), name: ScoreKeeper.ScoreDidChange, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    // MARK - Notifications
    
    @objc fileprivate func handleScoreDidChange(_ notification:Notification) {
        
        let scoreItem = notification.userInfo?[ ScoreKeeper.ScoreDidChangeNotificationKeys.scoreItem ] as! ScoreKeeper.ScoreItems
        let newScore = notification.userInfo?[ ScoreKeeper.ScoreDidChangeNotificationKeys.newScore ] as! Int
        
        let progress = Float(newScore) / Float(ScoreKeeper.maxScore) * 100
        scoreBar(for: scoreItem).setProgress(CGFloat(progress), animated: true, duration: 2.5)
        
    }
    
    // MARK - Helpers
    
    fileprivate func label(for item:ScoreKeeper.ScoreItems) -> UILabel {
        switch item {
        case .health:
            return healthLabel
        case .money:
            return moneyLabel
        case .time:
            return timeLabel
        case .community:
            return communityLabel
        }
    }
    
    fileprivate func scoreBar(for item:ScoreKeeper.ScoreItems) -> LinearProgressBar {
        switch item {
        case .health:
            return healthScore
        case .money:
            return moneyScore
        case .time:
            return timeScore
        case .community:
            return communityScore
        }
    }
    
}
