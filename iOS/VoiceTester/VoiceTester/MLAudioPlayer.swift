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
    func RecordingEnded(data: [[Int16]]?)
}

class MLAudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var recorder : AVAudioRecorder?
    private var player : AVAudioPlayer?
    private var engine : AVAudioPCMBuffer?
    
    private let recordingSettings : [String : AnyObject] = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                                    AVNumberOfChannelsKey : 1]
    private var recordURL : URL!
    private var timer : Timer?
    
    private var audioData = [[Int16]]()
    
    weak var delegate: MLAudioPlayerDelegate?
    
    override init() {
        super.init()
        let appDelegate = UIApplication.shared().delegate as! AppDelegate
        let documentsURL = appDelegate.applicationDocumentsDirectory
        recordURL = documentsURL.appendingPathComponent("recording.m4a")
        print(recordURL)
        do
        {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try audioSession.setActive(true)
            
            recorder = try AVAudioRecorder(url: recordURL, settings: recordingSettings)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
        } catch {
            print(error)
        }
        
        
        NotificationCenter.default().addObserver(self, selector: #selector(test), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func test(userInfo: AnyObject) {
        print("Testing")
    }
    
    
    func Record() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
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
        if recorder?.isRecording != nil {
            recorder?.stop()
            timer?.invalidate()
            do {
                player = try AVAudioPlayer(contentsOf: recordURL)
                testingBufferSamples()
                player?.delegate = self
                delegate?.RecordingEnded(data: audioData)
            } catch {
            }
        }
        if player?.isPlaying != nil {
            player?.stop()
        }
        do {
            try audioSession.setActive(false)
        } catch {
        }
    }
    
    func testingBufferSamples() {
        do {
            let test = AVAsset(url: recordURL)
            let testManager = try AVAssetReader(asset: test)
            let track = test.tracks[0]
            let trackOutput = AVAssetReaderTrackOutput(track: track, outputSettings: [AVFormatIDKey : Int(kAudioFormatLinearPCM)])
            //print(trackOutput)
            testManager.add(trackOutput)
            testManager.startReading()
            //print(testManager.status)
            
            audioData.removeAll()
            
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

                var sampleArray = [Int16]()
                
                for audioBuffer in audioBuffers {
                    
                    let samples = UnsafeMutableBufferPointer<Int16>(start: UnsafeMutablePointer(audioBuffer.mData),
                                                                    count: Int(audioBuffer.mDataByteSize)/sizeof(Int16))
                    sampleArray.append(contentsOf: samples)
                }
                audioData.append(sampleArray)
                
                sample = trackOutput.copyNextSampleBuffer()
            }
        } catch {
        }
    }
    
    func updateMeters() {
        recorder?.updateMeters()
        let power = recorder!.averagePower(forChannel: 0) + 160.0
        print(power)
        delegate?.RecordingEnded(data: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            delegate?.AudioEnded()
        }
    }

}
