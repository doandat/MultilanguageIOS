//
//  MultilanguagePlistModel.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import Foundation

class MultilanguagePlistModel {
    var iosKey: String
    var aosKey: String
    var tc: [String]
    var sc: [String]
    var en: [String]
    var vn: [String]
    var thai: [String]
    
    init(iosKey: String, aosKey: String, tc: [String], sc: [String], en: [String], vn: [String], thai: [String]) {
        self.iosKey = iosKey
        self.aosKey = aosKey
        self.tc = tc
        self.sc = sc
        self.en = en
        self.vn = vn
        self.thai = thai
    }
    
    func printLanguage(isIOS: Bool = true, language: LanguageKey) -> String {
        let key = isIOS ? iosKey : aosKey
        if en.count > 1 {
            var values: [String] = []
            switch language {
            case .tc:
                values = tc
            case .sc:
                values = sc
            case .en:
                values = en
            case .vi:
                values = vn
            case .thai:
                values = thai
            }
            let value = values.reduce("") { $0 + "\"\($1)\",\n" }
            return "\"\(key)\" = (\n\(value));"
        } else {
            switch language {
            case .tc:
                return "\"\(key)\" = \"\(tc[0])\";"
            case .sc:
                return "\"\(key)\" = \"\(sc[0])\";"
            case .en:
                return "\"\(key)\" = \"\(en[0])\";"
            case .vi:
                return "\"\(key)\" = \"\(vn[0])\";"
            case .thai:
                return "\"\(key)\" = \"\(thai[0])\";"
            }
        }
    }
    
}

