//
//  ScoreView.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/5/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

public let MAX_SCORE = 3

enum ScoreItems: String, CaseIterable {
    case health
    case money
    case time
    case community
}

class ScoreView: UIView {
    
    @IBOutlet var view: UIView!

    @IBOutlet weak var healthScore: LinearProgressBar!
    @IBOutlet weak var moneyScore: LinearProgressBar!
    @IBOutlet weak var timeScore: LinearProgressBar!
    @IBOutlet weak var communityScore: LinearProgressBar!
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    
    private var scores = [
        ScoreItems.health: MAX_SCORE,
        ScoreItems.money: MAX_SCORE,
        ScoreItems.time: MAX_SCORE,
        ScoreItems.community: MAX_SCORE
    ]
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let contentView = self.loadNib()!
        self.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ScoreItems.allCases.forEach { (item) in
            let bar = scoreBar(for: item)
            // TODO: Fix colors and ranges
            bar.barColorForValue = { value in
                switch value {
                case 0..<20:
                    return UIColor.red
                case 20..<60:
                    return UIColor.orange
                case 60..<80:
                    return UIColor.yellow
                default:
                    return UIColor.green
                }
            }
        }
    }
    
    func score(for item:ScoreItems) -> Int? {
        return scores[ item ]!
    }
    
    func setScore(score newScore: Int, for item:ScoreItems) {
        if ( scores[ item ] != newScore ) {
            scores[ item ] = newScore
            let progress = newScore / MAX_SCORE * 100
            scoreBar(for: item).setProgress(CGFloat(progress), animated: true, duration: 5)
        }
        
    }
    
    func setScores(scores newScores: [ScoreItems: Int], for item:ScoreItems) {
        newScores.forEach { (key: ScoreItems, value: Int) in
            setScore(score: value, for: key)
        }
    }
    
    fileprivate func label(for item:ScoreItems) -> UILabel {
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
    
    fileprivate func scoreBar(for item:ScoreItems) -> LinearProgressBar {
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
