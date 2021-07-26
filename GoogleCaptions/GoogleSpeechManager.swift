//
//  GoogleSpeechManager.swift
//  GoogleCaptions
//
//  Created by Jim Niemann on 7/23/21.
//

import Cocoa
import googleapis
import SwiftUI

class GoogleSpeechManager: NSObject {
    
    @StateObject var speechResults = SpeechResults()
    
    private static var speechRecorder: SpeechRecorder?
    
    class func startRecording() {
        AudioController.sharedInstance.delegate = AudioDelegate.shared
        
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: 16000)
        SpeechRecognitionService.sharedInstance.sampleRate = 16000
        let status = AudioController.sharedInstance.start()
        print(status)
        
        speechRecorder = SpeechRecorder()
        try? speechRecorder?.startRecording()
    }
    
    class func stopRecording() {
//        _ = AudioController.sharedInstance.stop()
//        SpeechRecognitionService.sharedInstance.stopStreaming()
        
        speechRecorder?.stopRecording()
    }
}

class AudioDelegate: AudioControllerDelegate {
    
    public static var shared = AudioDelegate()
    
    var audioData = NSMutableData()
    
    func processSampleData(_ data: Data) -> Void {
        print("processSampleData: data.count=\(data.count)")
        
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
                                                        * Double(16000) /* samples/second */
                                                        * 2 /* bytes/sample */);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                                                                        { [weak self] (response, error) in
                                                                            guard let strongSelf = self else {
                                                                                return
                                                                            }
                                                                            
                                                                            if let error = error {
                                                                                print(error.localizedDescription)
                                                                                
                                                                            } else if let response = response {
                                                                                var fullTranscript = ""
                                                                                
                                                                                var finished = false
                                                                                print(response)
                                                                                for result in response.resultsArray ?? [] {
                                                                                    
                                                                                    if let result = result as? StreamingRecognitionResult {
                                                                                        for alternative in result.alternativesArray {
                                                                                            if let transcript = (alternative as? SpeechRecognitionAlternative)?.transcript,
                                                                                               !transcript.isEmpty {
                                                                                                fullTranscript = transcript
                                                                                            }
                                                                                        }
                                                                                        if result.isFinal {
                                                                                            finished = true
                                                                                            break
                                                                                        }
                                                                                    }
                                                                                }

                                                                                print("transcript=\(fullTranscript)")
                                                                                
                                                                                if finished {
                                                                                    Notification.Name.TranscriptReceived.post(object: fullTranscript)
                                                                                    
//                                                                                    strongSelf.stopAudio(strongSelf)
                                                                                }
                                                                            }
                                                                        })
            self.audioData = NSMutableData()
        }
    }
}

