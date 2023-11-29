//
//  LanguageKey.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import Foundation

enum LanguageKey: String {
    case en
    case vi
    case ko
    case tc
    case sc
    
    var toKey: String {
        switch self {
        case .en:
            return "en"
        case .vi:
            return "vi"
        case .ko:
            return "ko"
        case .tc:
            return "zh-Hant"
        case .sc:
            return "zh-Hans"
        }
    }
}



class MultilanguageModel {
    var iosKey: String
    var aosKey: String
    var en: String
    var vi: String
    var thai: String
    var tc: String
    var sc: String
    
    init(iosKey: String, aosKey: String, en: String, vi: String, thai: String, tc: String, sc: String) {
        self.iosKey = iosKey
        self.aosKey = aosKey
        self.en = en
        self.vi = vi
        self.thai = thai
        self.tc = tc
        self.sc = sc
    }
    
    func printLanguage(isIOS: Bool = true, language: LanguageKey) -> String {
        let key = isIOS ? iosKey : aosKey
        switch language {
        case .en:
            return "\"\(key)\" = \"\(en)\";"
        case .vi:
            return "\"\(key)\" = \"\(vi)\";"
        case .ko:
            return "\"\(key)\" = \"\(thai)\";"
        case .tc:
            return "\"\(key)\" = \"\(tc)\";"
        case .sc:
            return "\"\(key)\" = \"\(sc)\";"
        }
    }
    
}

