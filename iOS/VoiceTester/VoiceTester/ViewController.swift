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
        waveView.updateWaveForm(data: data)
    }

    @IBAction func Previous(sender : UIButton) {
        sender.isEnabled = waveView.Previous(step: 1)
        if !nextBtn.isEnabled {
            nextBtn.isEnabled = true
        }
    }
    
    @IBAction func Next(sender: UIButton) {
        sender.isEnabled = waveView.Next(step: 1)
        if !previousBtn.isEnabled {
            previousBtn.isEnabled = true
        }
    }
    
    @IBAction func Record(sender : UIButton) {
        player.Record()
        playBtn.isEnabled = false
        stopBtn.isEnabled = true
        recordBtn.isEnabled = false
        previousBtn.isEnabled = false
        nextBtn.isEnabled = false
    }
    
    @IBAction func Play(sender : UIButton) {
        player.Play()
        playBtn.isEnabled = false
        recordBtn.isEnabled = false
        stopBtn.isEnabled = true
        pauseBtn.isEnabled = true
    }
    
    @IBAction func Pause(sender : UIButton) {
        player.Pause()
        pauseBtn.isEnabled = false
        playBtn.isEnabled = true
        stopBtn.isEnabled = false
    }
    
    @IBAction func Stop(sender : UIButton) {
        player.Stop()
        ChangeToStopState()
    }
    
    func ChangeToStopState() {
        stopBtn.isEnabled = false
        pauseBtn.isEnabled = false
        playBtn.isEnabled = true
        recordBtn.isEnabled = true
        previousBtn.isEnabled = true
        nextBtn.isEnabled = true
    }
}

