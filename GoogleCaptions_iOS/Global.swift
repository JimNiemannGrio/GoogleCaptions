//
//  Global.swift
//  Global
//
//  Created by Jim Niemann on 7/22/21.
//

import SwiftUI

public class Global: ObservableObject {
    
    public static var shared = Global()
    
    @Published var speechResults = SpeechResults()
}
