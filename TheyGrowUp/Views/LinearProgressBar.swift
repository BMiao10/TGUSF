//
//  LinearProgressBar.swift
//  LinearProgressBar
//
//  Initial work by Eliel Gordon.
//  Significantly revised by Jared Shenson, (C) 2018
//

import UIKit

extension Comparable {
    func clamped(lowerBound: Self, upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}

/// Draws a progress bar
@IBDesignable
open class LinearProgressBar: UIView {
    
    /// The color of the progress bar
    @IBInspectable public var barColor: UIColor = UIColor.green
    /// The color of the base layer of the bar
    @IBInspectable public var trackColor: UIColor = UIColor.yellow
    /// Outer border color
    @IBInspectable public var borderColor: UIColor = UIColor.black
    /// Orientation of progress bar: left to right, or bottom to top
    @IBInspectable public var barOrientationHorizontal: Bool = true
    
    /// Outer border thickness
    @IBInspectable public var borderThickness: CGFloat = 0 {
        didSet {
            if borderThickness < 0 {
                borderThickness = 0
            }
        }
    }
    
    /// Corner radius
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius < 0 {
                cornerRadius = 0
            } else if cornerRadius > trackHeight / 2 {
                cornerRadius = trackHeight / 2
            }
        }
    }
    
    
    /// Padding on the track on the progress bar
    @IBInspectable public var trackPadding: CGFloat = 0 {
        didSet {
            if trackPadding < 0 {
                trackPadding = 0
            } else if trackPadding + borderThickness > trackHeight / 2 {
                trackPadding = trackHeight / 2 - borderThickness
            }
        }
    }
    
    @IBInspectable public dynamic var progress: CGFloat = 0 {
        didSet {
            progressLayer.progress = progress.clamped(lowerBound: 0, upperBound: 100)
        }
    }
    
    fileprivate var trackHeight: CGFloat {
        return barOrientationHorizontal == true ? frame.size.height : frame.size.width
    }
    
    fileprivate var trackOffset: CGFloat {
        return borderThickness + trackPadding
    }
    
    fileprivate var progressLayer: LinearProgressBarLayer {
        return layer as! LinearProgressBarLayer
    }
    
    override open class var layerClass: AnyClass {
        return LinearProgressBarLayer.self
    }
    
    open var barColorForValue: ((Float)->UIColor)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setProgress(_ newProgress: CGFloat, animated: Bool, duration: Double) {
        
        if animated == true {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.progress = newProgress
            }, completion: nil)
        } else {
            progress = newProgress
        }
    }
    
    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == #keyPath(LinearProgressBarLayer.progress),
            let action = action(for: layer, forKey: #keyPath(backgroundColor)) as? CAAnimation {
            
            let animation = CABasicAnimation()
            animation.keyPath = #keyPath(LinearProgressBarLayer.progress)
            animation.fromValue = progressLayer.progress
            animation.toValue = progress
            animation.beginTime = action.beginTime
            animation.duration = action.duration
            animation.speed = action.speed
            animation.timeOffset = action.timeOffset
            animation.repeatCount = action.repeatCount
            animation.repeatDuration = action.repeatDuration
            animation.autoreverses = action.autoreverses
            animation.fillMode = action.fillMode
            animation.timingFunction = action.timingFunction
            animation.delegate = action.delegate
            self.layer.add(animation, forKey: #keyPath(LinearProgressBarLayer.progress))
        }
        return super.action(for: layer, forKey: event)
    }
    
    /// Clear graphics context and redraw on bounds change
    func setup() {
        clearsContextBeforeDrawing = true
        self.contentMode = .redraw
        clipsToBounds = false
        self.layer.delegate = self
    }
    
}

/*
 * Concepts taken from:
 * https://stackoverflow.com/questions/14192816/create-a-custom-animatable-property/44961463#44961463
 */
fileprivate class LinearProgressBarLayer: CALayer {
    @NSManaged var progress: CGFloat
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(progress) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    fileprivate var trackHeight: CGFloat {
        return frame.size.height
    }
    
    fileprivate var trackOffset: CGFloat {
        let lpb = self.delegate as! LinearProgressBar
        return lpb.borderThickness + lpb.trackPadding
    }
    
    open override func draw(in context: CGContext) {
        super.draw(in: context)
        
        let lpb = self.delegate as! LinearProgressBar
        
        // Draw track with border, if applicable
        let insetPath = CGRect(origin: CGPoint(x:0,y:0), size: frame.size).insetBy(dx: lpb.borderThickness / 2, dy: lpb.borderThickness / 2)
        let track = CGPath(roundedRect: insetPath, cornerWidth: lpb.cornerRadius, cornerHeight: lpb.cornerRadius, transform: nil)
        context.addPath(track)
        context.setFillColor(lpb.trackColor.cgColor)
        context.fillPath()
        
        context.addPath(track)
        context.setStrokeColor(lpb.borderColor.cgColor)
        context.setLineWidth(lpb.borderThickness)
        context.strokePath()
        
        // Draw bar
        var barPath: CGRect
        if lpb.barOrientationHorizontal == true {
            barPath = CGRect(x: trackOffset, y: trackOffset, width: trackOffset + calculatePercentage(), height: frame.size.height - (trackOffset * 2))
        } else {
            barPath = CGRect(x: trackOffset, y: frame.size.height - trackOffset - calculatePercentage(), width: frame.size.width - (trackOffset * 2), height: calculatePercentage())
        }
        
        let barCornerRadius = (lpb.cornerRadius - 1) < barPath.height / 2 ? lpb.cornerRadius - 1 : barPath.height / 2
        let barPathRounded = CGPath(roundedRect: barPath, cornerWidth: barCornerRadius, cornerHeight: barCornerRadius, transform: nil)
        let colorForBar = lpb.barColorForValue?(Float(progress)) ?? lpb.barColor
        context.addPath(barPathRounded)
        context.setFillColor(colorForBar.cgColor)
        context.fillPath()
        
        //print("completed draw @ \(Date.init().description)")
    }
    
    /// Calculates the percent value of the progress bar
    ///
    /// - Returns: The percentage of progress
    func calculatePercentage() -> CGFloat {
        let lpb = self.delegate as! LinearProgressBar
        let orientedLength = lpb.barOrientationHorizontal == true ? frame.size.width : frame.size.height
        let availWidth = orientedLength - (trackOffset * 2)
        let pct = ((progress / 100) * availWidth)
        return pct < 0 ? 0 : pct
    }
}
