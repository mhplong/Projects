//
//  WaveFormView.swift
//  VoiceTester
//
//  Created by Mark Long on 6/9/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit

class WaveFormView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var waveFormData = [Int16]()
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        drawStuff(rect.height)
    }
    
    func drawStuff(height: CGFloat) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: height / 2))
        var count = 0
        for sample in waveFormData {
            let offset = Int(height / 2)
            path.addLineToPoint(CGPoint(x: count, y: (offset + Int(sample))))
            count = count + 1
        }
        UIColor.yellowColor().setStroke()
        path.stroke()
    }
    
    func updateWaveForm(data:[Int16]) {
        waveFormData = data
        print(data.count)
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
