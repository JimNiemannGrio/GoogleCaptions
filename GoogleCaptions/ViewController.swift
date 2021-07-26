//
//  ViewController.swift
//  GoogleCaptions
//
//  Created by Jim Niemann on 7/23/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var transcriptDisplay: NSTextView?
    @IBOutlet var recordButtonBackground: NSView?
    @IBOutlet var recordButtonView: NSButton?
    var recordButton: RecordButton?
    
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let recordButtonBackground = recordButtonBackground else { return }

        let recordButtonSize:CGFloat = 56.0
        recordButton = RecordButton(frame: CGRect(x: 0,
                                                  y: 0,
                                                      width: recordButtonSize,
                                                      height: recordButtonSize))
        if let recordButton = recordButton {
            recordButtonView?.addSubview(recordButton)
        }

        recordButtonBackground.backgroundColor = .gray
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: AnyObject) {
        print("recordButtonTapped")

        isRecording = !isRecording
        
        if isRecording {
            print("Start recording")
            transcriptDisplay?.string = "recording..."

            GoogleSpeechManager.startRecording()

        } else {
            print("Stop recording")
            transcriptDisplay?.string = "transcript goes here"

            GoogleSpeechManager.stopRecording()
        }
    }
}
