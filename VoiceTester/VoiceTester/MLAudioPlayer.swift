//
//  MLAudioPlayer.swift
//  VoiceTester
//
//  Created by Mark Long on 6/5/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import AVFoundation

class MLAudioPlayer: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private var recorder : AVAudioRecorder?
    private var player : AVAudioPlayer?
    
    private let recordingSettings : [String : AnyObject] = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                                    AVSampleRateKey : 44100.0,
                                                    AVNumberOfChannelsKey : 1]
    
    override init() {
        super.init()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let documentsURL = appDelegate.applicationDocumentsDirectory
        let recordURL = documentsURL.URLByAppendingPathComponent("recording.m4a")
        print(recordURL)
        do
        {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true)
            
            recorder = try AVAudioRecorder(URL: recordURL, settings: recordingSettings)
            recorder?.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    
    func Record() {
        recorder?.record()
    }
    
    func Play() {
        
    }
    
    func Pause() {
        
    }
    
    func Stop() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            
        }
        recorder?.stop()
    }
}
