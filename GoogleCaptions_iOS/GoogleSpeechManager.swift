//
//  GoogleSpeechManager.swift
//  GoogleSpeak1
//
//  Created by Jim Niemann on 7/19/21.
//

import UIKit
import googleapis
import SwiftUI

class GoogleSpeechManager: NSObject {
    
    @StateObject var speechResults = SpeechResults()
    
    class func startRecording() {
        AudioController.sharedInstance.delegate = AudioDelegate.shared
        
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: 16000)
        SpeechRecognitionService.sharedInstance.sampleRate = 16000
        _ = AudioController.sharedInstance.start()
    }
    
    class func stopRecording() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
}

class AudioDelegate: AudioControllerDelegate {
    
    public static var shared = AudioDelegate()
    
    var audioData = NSMutableData()
    
    func processSampleData(_ data: Data) -> Void {
//        print("processSampleData: data.count=\(data.count)")
        
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
                    //                  strongSelf.textView.text = error.localizedDescription
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
                                
                                if let words = (alternative as? SpeechRecognitionAlternative)?.wordsArray, words.count > 0 {
                                    print(words)
                                    
                                    for word in words {
                                        if let word2 = word as? WordInfo {
                                            print(word2)
                                            let test = word2.startTime
                                            print(test)
                                        }
                                    }
                                }
                                
//                                if let words = (alternative as? SpeechRecognitionAlternative)? {
//                                    for word in words {
//                                        print(word)
//                                    }
//                                }
                            }
                            
                            if result.isFinal {
                                finished = true
                            }
                        }
                    }
                    
                    print("transcript=\(fullTranscript)")
                    
                    if finished {
                        Notification.Name.TranscriptReceived.post(object: fullTranscript)
                        //                    strongSelf.stopAudio(strongSelf)
                    }
                }
            })
            self.audioData = NSMutableData()
        }
    }
}

