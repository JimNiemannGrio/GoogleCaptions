//
//  SpeechResults.swift
//  GoogleSpeak1
//
//  Created by Jim Niemann on 7/20/21.
//

import SwiftUI

class SpeechResults: ObservableObject {
    
    @Published var descriptionReturned: String?
    
    func clear() {
        descriptionReturned = nil
    }
}
