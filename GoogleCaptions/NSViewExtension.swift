//
//  NSViewExtension.swift
//  GoogleCaptions
//
//  Created by Jim Niemann on 7/23/21.
//

import Cocoa

extension NSView {
    
    var backgroundColor: NSColor? {
        get {
            guard let backgroundColor = layer?.backgroundColor else { return nil }
            
            return NSColor(cgColor: backgroundColor)
        }
        
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
            alphaValue = 1.0
        }
    }
}
