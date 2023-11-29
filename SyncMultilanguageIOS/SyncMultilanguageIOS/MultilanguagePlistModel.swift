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
            case .ko:
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
            case .ko:
                return "\"\(key)\" = \"\(thai[0])\";"
            }
        }
    }

    
    func printSedCommand(isIOS: Bool = true, language: LanguageKey) -> String {
        let key = isIOS ? iosKey : aosKey
        return "find /Users/doandat/Documents/OCBGit/OCBNewOMNI1 -type f -name \"*.swift\" -exec sed -i '' 's/\"\(vn[0])\"/\(key.convertToLocalizationKey())/g' {} +"
        
//        return "find /Users/doandat/Documents/OCBGit/OCBNewOMNI1/Packages/RewardKit -type f -name \"*.swift\" -exec sed -i '' 's/\"\(vn[0])\"/\(key.convertToLocalizationKey())/g' {} +"
    
    }
    
}

extension String {
    func convertToLocalizationKey() -> String {
            var components = self.components(separatedBy: ".")

            for i in 0..<(components.count - 1) {
                components[i] = components[i].prefix(1).uppercased() + components[i].dropFirst()
            }

            components.insert("L10n", at: 0)
            return components.joined(separator: ".")
        }
}



class MultilanguageStringDictModel {
    var iosKey: String
    var aosKey: String
    var enKey: [String]
    var en: [String]
    var vnKey: [String]
    var vn: [String]
    var koKey: [String]
    var ko: [String]
    
    
    init(iosKey: String, aosKey: String, enKey: [String], en: [String], vnKey: [String], vn: [String], koKey: [String], ko: [String]) {
        self.iosKey = iosKey
        self.aosKey = aosKey
        self.enKey = enKey
        self.en = en
        self.vnKey = vnKey
        self.vn = vn
        self.koKey = koKey
        self.ko = ko
    }
    
    func printLanguage(isIOS: Bool = true, language: LanguageKey) -> String {
        let key = isIOS ? iosKey : aosKey
        var keyAndValue = ""
        for i in (0..<en.count) {
            var keyT = enKey[i]
            var valueT = en[i]
            switch language {
            case .en:
                keyT = enKey[i]
                valueT = en[i]
            case .vi:
                keyT = vnKey[i]
                valueT = vn[i]
            case .ko:
                keyT = koKey[i]
                valueT = ko[i]
            case .tc:
                keyT = enKey[i]
                valueT = en[i]
            case .sc:
                keyT = enKey[i]
                valueT = en[i]
            }
            keyAndValue = "\(keyAndValue)<key>\(keyT)</key><string>\(valueT)</string>"
        }
        let result = "<key>\(key)</key><dict><key>NSStringLocalizedFormatKey</key><string>%#@value@</string><key>value</key><dict><key>NSStringFormatSpecTypeKey</key><string>NSStringPluralRuleType</string><key>NSStringFormatValueTypeKey</key><string>d</string>\(keyAndValue)</dict></dict>"
        return result
    }    
}

