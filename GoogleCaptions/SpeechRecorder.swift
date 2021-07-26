//
//  SpeechRecorder.swift
//  GoogleCaptions
//
//  Created by Jim Niemann on 7/23/21.
//

import Foundation
import AVFoundation

class SpeechRecorder: NSObject {
    
    private let audioEngine = AVAudioEngine()
    
    func startRecording() throws {
        
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            print("buffer.frameLength=\(buffer.frameLength), sampleTime=\(when.sampleTime)")
            
            if let bufferData = buffer.floatChannelData {
                let data = Data(bytes: bufferData, count: Int(buffer.frameLength))
                AudioController.sharedInstance.delegate.processSampleData(data)
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording() {
        guard audioEngine.isRunning else { return }
        
        audioEngine.stop()
    }
}
