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
    
    func xibSetup() {
        let xib = self.loadNib()!
        self.addSubview(xib)
        xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xib.frame = self.bounds
        contentView = xib
        
        ScoreItems.allCases.forEach { (item) in
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
    
    func score(for item:ScoreItems) -> Int? {
        return scores[ item ]!
    }
    
    func setScore(score newScore: Int, for item:ScoreItems) {
        if ( scores[ item ] != newScore ) {
            scores[ item ] = newScore
            let progress = Float(newScore) / Float(MAX_SCORE) * 100
            scoreBar(for: item).setProgress(CGFloat(progress), animated: true, duration: 2.5)
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