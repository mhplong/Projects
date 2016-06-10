//
//  ViewController.swift
//  VoiceTester
//
//  Created by Mark Long on 6/1/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MLAudioPlayerDelegate {
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var waveView: WaveFormView!
    
    var player : MLAudioPlayer!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        player = MLAudioPlayer()
        player.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AudioEnded() {
        ChangeToStopState()
    }
    
    func RecordingEnded(data: [[Int16]]?) {
        waveView.updateWaveForm(data)
    }

    @IBAction func Previous(sender : UIButton) {
        sender.enabled = waveView.Previous(1)
        if !nextBtn.enabled {
            nextBtn.enabled = true
        }
    }
    
    @IBAction func Next(sender: UIButton) {
        sender.enabled = waveView.Next(1)
        if !previousBtn.enabled {
            previousBtn.enabled = true
        }
    }
    
    @IBAction func Record(sender : UIButton) {
        player.Record()
        playBtn.enabled = false
        stopBtn.enabled = true
        recordBtn.enabled = false
        previousBtn.enabled = false
        nextBtn.enabled = false
    }
    
    @IBAction func Play(sender : UIButton) {
        player.Play()
        playBtn.enabled = false
        recordBtn.enabled = false
        stopBtn.enabled = true
        pauseBtn.enabled = true
    }
    
    @IBAction func Pause(sender : UIButton) {
        player.Pause()
        pauseBtn.enabled = false
        playBtn.enabled = true
        stopBtn.enabled = false
    }
    
    @IBAction func Stop(sender : UIButton) {
        player.Stop()
        ChangeToStopState()
    }
    
    func ChangeToStopState() {
        stopBtn.enabled = false
        pauseBtn.enabled = false
        playBtn.enabled = true
        recordBtn.enabled = true
        previousBtn.enabled = true
        nextBtn.enabled = true
    }
}

