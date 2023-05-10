//
//  String+Extension.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import Foundation

extension String {
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var correctStringFromLocalize: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
    
    var correctStringFromGoogleSheet: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "%d", with: "%@")
            .replacingOccurrences(of: "%s", with: "%@")
            .replacingOccurrences(of: "%f", with: "%@")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
