//
//  MLAudioPlayer.swift
//  VoiceTester
//
//  Created by Mark Long on 6/5/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import AVFoundation

protocol MLAudioPlayerDelegate : NSObjectProtocol {
    func AudioEnded()
    func RecordingEnded(data: [Int16])
}

class MLAudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var recorder : AVAudioRecorder?
    private var player : AVAudioPlayer?
    private var engine : AVAudioPCMBuffer?
    
    private let recordingSettings : [String : AnyObject] = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                                    AVNumberOfChannelsKey : 1]
    private var recordURL : NSURL!
    private var timer : NSTimer?
    
    private var audioData = [Int16]()
    
    weak var delegate: MLAudioPlayerDelegate?
    
    override init() {
        super.init()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let documentsURL = appDelegate.applicationDocumentsDirectory
        recordURL = documentsURL.URLByAppendingPathComponent("recording.m4a")
        print(recordURL)
        do
        {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true)
            
            recorder = try AVAudioRecorder(URL: recordURL, settings: recordingSettings)
            recorder?.meteringEnabled = true
            recorder?.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    
    func Record() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
        recorder?.record()
    }
    
    func Play() {
        player?.play()
    }
    
    func Pause() {
        player?.pause()
    }
    
    func Stop() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            
        }
        if recorder?.recording != nil {
            recorder?.stop()
            timer?.invalidate()
            do {
                player = try AVAudioPlayer(contentsOfURL: recordURL)
                testingBufferSamples()
                player?.delegate = self
                delegate?.RecordingEnded(audioData)
            } catch {
            }
        }
        if player?.playing != nil {
            player?.stop()
        }
        var minSample = Int16.max, maxSample = Int16.min
        for sample in audioData {
            minSample = min(sample, minSample)
            maxSample = max(sample, maxSample)
        }
        print("\(minSample) : \(maxSample)")
    }
    
    func testingBufferSamples() {
        do {
            let test = AVAsset(URL: recordURL)
            let testManager = try AVAssetReader(asset: test)
            let track = test.tracks[0]
            let trackOutput = AVAssetReaderTrackOutput(track: track, outputSettings: [AVFormatIDKey : Int(kAudioFormatLinearPCM)])
            //print(trackOutput)
            testManager.addOutput(trackOutput)
            testManager.startReading()
            //print(testManager.status)
            
            audioData = [Int16]()
            
            var sample = trackOutput.copyNextSampleBuffer()
            while sample != nil {
                
                var bufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: AudioBuffer(mNumberChannels: 0, mDataByteSize: 0, mData: nil))
                
                var buffer : CMBlockBuffer? = nil
                
                CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sample!,
                                                                        nil,
                                                                        &bufferList,
                                                                        sizeofValue(bufferList),
                                                                        nil,
                                                                        nil,
                                                                        kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
                                                                        &buffer)
                
                let audioBuffers = UnsafeBufferPointer<AudioBuffer>(start: &bufferList.mBuffers, count: Int(bufferList.mNumberBuffers))

                for audioBuffer in audioBuffers {
                    
                    let samples = UnsafeMutableBufferPointer<Int16>(start: UnsafeMutablePointer(audioBuffer.mData),
                                                                    count: Int(audioBuffer.mDataByteSize)/sizeof(Int16))
                    audioData.appendContentsOf(samples)
                }
                
                
                sample = trackOutput.copyNextSampleBuffer()
            }
        } catch {
        }
    }
    
    func updateMeters() {
        recorder?.updateMeters()
        let power = recorder!.averagePowerForChannel(0) + 160.0
        print(power)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            delegate?.AudioEnded()
        }
    }

}
