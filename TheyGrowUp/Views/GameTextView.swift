//
//  GameTextView.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/13/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

@IBDesignable
class GameTextView: UIView {

    @IBInspectable
    var bgColor: UIColor = UIColor.black {
        didSet {
            drawBackground()
        }
    }
    
    private var path: UIBezierPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        drawBackground()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawBackground()
    }
    
    private func drawBackground () {
        path = UIBezierPath()
        path.move(to: .zero)
        path.addCurve(to: CGPoint(x: 29, y: 0.36 * self.frame.size.height),
                      controlPoint1: .zero,
                      controlPoint2: CGPoint(x: 29, y: 0.18 * self.frame.size.height))
        path.addCurve(to: CGPoint(x: 0, y: 0.84 * self.frame.size.height),
                      controlPoint1: CGPoint(x: 29, y: 0.54 * self.frame.size.height),
                      controlPoint2: CGPoint(x: 0, y: 0.72 * self.frame.size.height))
        path.addCurve(to: CGPoint(x: 5, y: self.frame.size.height),
                      controlPoint1: CGPoint(x: 0, y: 0.96 * self.frame.size.height),
                      controlPoint2: CGPoint(x: 5, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = bgColor.withAlphaComponent(0.9).cgColor
        shapeLayer.shadowColor = bgColor.cgColor
        shapeLayer.shadowOffset = CGSize(width: -2, height: 0)
        shapeLayer.shadowRadius = 8
        shapeLayer.shadowOpacity = 0.20
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }

}
