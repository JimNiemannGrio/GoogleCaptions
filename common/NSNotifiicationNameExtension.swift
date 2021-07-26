//
//  NSNotifiicationNameExtension.swift
//  GoogleSpeechToText2
//
//  Created by Jim Niemann on 7/22/21.
//

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

extension Notification.Name {
    
    static let TranscriptReceived = Notification.Name("TranscriptReceived")
    
    func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}

