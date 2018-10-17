//
//  ChildAgeView.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/16/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import UIKit

@IBDesignable
class ChildAgeView: UIView {

    private var contentView: UIView?
    
    var ageNumber: Int = 1  {
        didSet {
            setupUI()
        }
    }
    
    var ageScale: String = "Day" {
        didSet {
            setupUI()
        }
    }
    
    var gender: Gender = .male {
        didSet {
            setupUI()
        }
    }
    
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageScaleLabel: UILabel!
    
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard
            let views = bundle.loadNibNamed("ChildAgeView", owner: self, options: nil),
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
        
        setupUI()
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

    private func setupUI() {
        let fileName = ChildImages.forAge(number: ageNumber, scale: ageScale).fileNameForGender(gender)
        childImage.image = UIImage(named: fileName)
        
        ageLabel.text = String(ageNumber)
        ageScaleLabel.text = ageScale
    }

}
