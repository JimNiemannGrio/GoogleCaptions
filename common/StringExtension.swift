//
//  StringExtension.swift
//  GoogleCaptions
//
//  Created by Jim Niemann on 7/23/21.
//

import Foundation

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
