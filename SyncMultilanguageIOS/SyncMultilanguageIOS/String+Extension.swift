//
//  String+Extension.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstLowercase: String { return prefix(1).lowercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}


extension String {
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var correctStringFromLocalize: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
    var correctStringFromGoogleSheetIOS: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "%d", with: "%@")
            .replacingOccurrences(of: "%1$d", with: "%1$@")
            .replacingOccurrences(of: "%2$d", with: "%2$@")
            .replacingOccurrences(of: "%3$d", with: "%3$@")
            .replacingOccurrences(of: "%4$d", with: "%4$@")
            .replacingOccurrences(of: "%5$d", with: "%5$@")
            .replacingOccurrences(of: "%s", with: "%@")
            .replacingOccurrences(of: "%1$s", with: "%1$@")
            .replacingOccurrences(of: "%2$s", with: "%2$@")
            .replacingOccurrences(of: "%3$s", with: "%3$@")
            .replacingOccurrences(of: "%4$s", with: "%4$@")
            .replacingOccurrences(of: "%5$s", with: "%5$@")
            .replacingOccurrences(of: "%f", with: "%@")
            .replacingOccurrences(of: "%1$f", with: "%1$@")
            .replacingOccurrences(of: "%2$f", with: "%2$@")
            .replacingOccurrences(of: "%3$f", with: "%3$@")
            .replacingOccurrences(of: "%4$f", with: "%4$@")
            .replacingOccurrences(of: "%5$f", with: "%5$@")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var correctStringFromGoogleSheetAndroid: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
