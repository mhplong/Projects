//
//  ViewController.swift
//  VoiceTester
//
//  Created by Mark Long on 6/1/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var player : MLAudioPlayer!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        player = MLAudioPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Record(sender : UIButton) {
        player.Record()
    }
    
    @IBAction func Play(sender : UIButton) {
        player.Play()
    }
    
    @IBAction func Pause(sender : UIButton) {
        player.Pause()
    }
    
    @IBAction func Stop(sender : UIButton) {
        player.Stop()
    }
}

