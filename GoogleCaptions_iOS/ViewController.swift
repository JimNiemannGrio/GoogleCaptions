//
//  ViewController.swift
//  GoogleSpeechToText2
//
//  Created by Jim Niemann on 7/22/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var transcriptDisplay: UITextView?
    @IBOutlet var recordButtonBackground: UIView?
    var recordButton: RecordButton?
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Notification.Name.TranscriptReceived.onPost(queue: .main) { [weak self] notification in
            guard let `self` = self,
                  let newTranscript = notification.object as? String //,
//                  let oldTranscript = self.transcriptDisplay?.text,
//                  oldTranscript.isEmpty || (newTranscript.count > oldTranscript.count)
            else { return }
            
            self.transcriptDisplay?.text += "\n" + newTranscript.trimmed
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let recordButtonBackground = recordButtonBackground else { return }

        let recordButtonSize:CGFloat = 56.0
        recordButton = RecordButton(frame: CGRect(x: view.bounds.width / 2 - recordButtonSize / 2,
                                                  y: recordButtonBackground.frame.origin.y + (recordButtonBackground.frame.height - recordButtonSize) / 2 - 10,
                                                      width: recordButtonSize,
                                                      height: recordButtonSize))
        recordButton?.delegate = self

        if let recordButton = recordButton {
            self.view.addSubview(recordButton)
        }
    }
}

extension ViewController: RecordButtonDelegate {

    func tapButton(isRecording: Bool) {

        if isRecording {
            print("Start recording")
            transcriptDisplay?.text = ""

            GoogleSpeechManager.startRecording()

        } else {
            print("Stop recording")

            GoogleSpeechManager.stopRecording()
        }
    }
}
