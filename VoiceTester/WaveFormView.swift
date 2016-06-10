//
//  WaveFormView.swift
//  VoiceTester
//
//  Created by Mark Long on 6/9/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit

func normalize(value: CGFloat, max : CGFloat, min: CGFloat) -> CGFloat {
    return (value - min)/(max - min)
}

func lerp(norm: CGFloat, max : CGFloat, min: CGFloat) -> CGFloat {
    return (max - min) * norm + min
}

func map(value: CGFloat, maxTarget: CGFloat, minTarget: CGFloat, maxDest : CGFloat, minDest: CGFloat) -> CGFloat {
    return lerp(normalize(value, max: maxTarget, min: minTarget), max: maxDest, min: minDest)
}

class WaveFormView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var stepWaveFormData = [Int16]()
    var wholeWaveFormData = [[Int16]]()
    
    var stepOffset = 0
    let stepLength = 4
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        drawStuff(rect.size)
    }
    
    func drawStuff(size: CGSize) {
        var count : CGFloat = 0
        var maxHeight : Int16 = 0
        var minHeight : Int16 = 0
        for sample in stepWaveFormData {
            if sample > maxHeight {
                maxHeight = sample
            }
            if sample < minHeight {
                minHeight = sample
            }
        }
        print("\(minHeight) - \(maxHeight)")
        let baseline = CGFloat(size.height / 2)
        var xPos = map(count, maxTarget: CGFloat(stepWaveFormData.count), minTarget: 0, maxDest: size.width, minDest: 0)
        var lastPoint = CGPoint(x: xPos, y:baseline)
        for sample in stepWaveFormData {
            let path = UIBezierPath()
            xPos = map(count, maxTarget: CGFloat(stepWaveFormData.count), minTarget: 0, maxDest: size.width, minDest: 0)
            let offset = map(CGFloat(sample), maxTarget: CGFloat(Int16.max), minTarget: 0, maxDest: size.height, minDest: 0)
            let linePoint = CGPoint(x: xPos, y: (baseline + offset))
            path.moveToPoint(lastPoint)
            path.addLineToPoint(linePoint)
            UIColor.yellowColor().setStroke()
            path.stroke()
            lastPoint = linePoint
            count = count + 1
        }
    }
    
    func updateWaveForm(data:[[Int16]]?) {
        if data != nil {
            wholeWaveFormData = data!
            updateForm()
        }
    }
    
    func updateForm() {
        stepWaveFormData = [Int16]()
        
        print(stepOffset)
        let endStep = stepOffset + stepLength
        for c in stepOffset..<endStep {
            if c < wholeWaveFormData.count {
                stepWaveFormData.appendContentsOf(wholeWaveFormData[c])
            }
        }
        self.setNeedsDisplay()
    }
    
    func Previous(step: Int) -> Bool {
        if stepOffset <= 0 {
            return false
        } else {
            stepOffset = stepOffset - stepLength
            updateForm()
            return true
        }
    }
    
    func Next(step: Int) -> Bool {
        if (stepOffset + stepLength) >= wholeWaveFormData.count {
            return false
        } else {
            stepOffset = stepOffset + stepLength
            updateForm()
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
