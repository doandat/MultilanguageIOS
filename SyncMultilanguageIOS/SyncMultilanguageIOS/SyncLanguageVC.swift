//
//  SyncLanguageVC.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

enum AppType {
    case retail
    case business
    
    var spreadsheetId: String {
        switch self {
        case .retail:
            return "1g0E9yjIcADua42ZT5MznYsDTUHkXo8xvXg8m-8CnfhI"
        case .business:
            return "1g0E9yjIcADua42ZT5MznYsDTUHkXo8xvXg8m-8CnfhI"
        }
    }
    
    var localizableFileName: String {
        switch self {
        case .retail:
            return "BBLocalizable"
        case .business:
            return "BBLocalizable"
        }
    }
}

class SyncLanguageVC: UIViewController {
    let sheetService = GTLRSheetsService()
    var appType: AppType = .retail
    var localLanguages: [MultilanguagePlistModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sheetService.apiKey = Constants.apiKey
        localLanguages = readLocalizableFile()
        
        let sheets = ["Backbase Retail App"]
        getDataBBGoogleSheet(sheets: sheets) {[weak self] results in
            guard let self else { return }
            for result in results {
                if let itemLocal = self.localLanguages.first(where: {$0.iosKey == result.iosKey}) {
                    itemLocal.en = result.en
                    itemLocal.sc = result.sc
                    itemLocal.tc = result.tc
                    itemLocal.vn = result.vn
                    itemLocal.thai = result.thai
                } else {
                    self.localLanguages.append(result)
                    print("warning key not found: \"\(result.iosKey)\"")
                }
            }
            self.writeNewData()
        }
    }
    
    
    @IBAction func actionEng(_ sender: Any) {
        writeNewData(language: .en)
    }
    @IBAction func actionVN(_ sender: Any) {
        writeNewData(language: .vi)
    }
    @IBAction func actionThai(_ sender: Any) {
        writeNewData(language: .thai)
    }
    @IBAction func actionTC(_ sender: Any) {
        writeNewData(language: .tc)
    }
    @IBAction func actionSC(_ sender: Any) {
        writeNewData(language: .sc)
    }
}

//read google sheet
extension SyncLanguageVC {
    func getDataFromBBGoogleSheet(sheetName: String, completionHandler: @escaping ([MultilanguagePlistModel]) -> Void) {
        var datas: [MultilanguagePlistModel] = []
        let spreadsheetId = appType.spreadsheetId
//        let spreadsheetId = "1lCRrxpoW696Zo9w2Z0TCdLxh2spWg0-TpNWpdP3HkFA"
        let range = "\(sheetName)!A:H"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        
        sheetService.executeQuery(query) { (ticket, result, error) in
            if let error = error {
                print(error)
                completionHandler([])
                return
            }
            guard let result = result as? GTLRSheets_ValueRange,
                  let rows = result.values as? [[String]] else {
                completionHandler([])
                return
            }
            var localizeStrings: [[String]] = []
            var arrStrings: [[[String]]] = []
            
            let stringRows = rows.filter({!$0.isEmpty})
            var isInArray = false
            var currentString = stringRows[1]
            var currentArray: [[String]] = []
            for index in 2..<stringRows.count {
                let row = stringRows[index]
                if row[0].isEmpty {
                    //array
                    if isInArray {
                        currentArray.append(row)
                    } else {
                        isInArray = true
                        currentArray.append(currentString)
                        currentArray.append(row)
                    }
                } else {
                    //localize only
                    if isInArray {
                        arrStrings.append(currentArray)
                        currentArray.removeAll()
                    } else {
                        localizeStrings.append(currentString)
                    }
                    currentString = row
                    isInArray = false
                }
            }
            if isInArray {
                arrStrings.append(currentArray)
            } else {
                localizeStrings.append(currentString)
            }
            
            let firstRow = stringRows[0]
            let indexEng = firstRow.firstIndex(of: "EN") ?? 1
            let indexVN = firstRow.firstIndex(of: "VN") ?? 2
            let indexThai = firstRow.firstIndex(of: "THAI") ?? 3
            
            var indexKey = 0
//            var startTC = 3
//            if firstRow[0] == "String ID" {
//                indexKey = 0
//                startTC = 3
//            } else if firstRow[1] == "String ID_IOS" || firstRow[1] == "iOS string ID" {
//                indexKey = 1
//                startTC = 4
//            }
            for row in localizeStrings {
                if row.isEmpty { continue }
//                print(row)
                let aosKey = row[indexKey].trim
                let iosKey = row[indexKey].trim
                if iosKey.isEmpty {
                    continue
                }
                if let en = row.sofValue(at: indexEng)?.correctStringFromGoogleSheet {
                    let vn = row.sofValue(at: indexVN)?.correctStringFromGoogleSheet ?? en
                    let thai = row.sofValue(at: indexThai)?.correctStringFromGoogleSheet ?? en
                    let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: aosKey, tc: [en], sc: [en], en: [en], vn: [vn], thai: [thai])
                    print(itemLang.printLanguage(language: .thai))
                    datas.append(itemLang)
                }
            }
//            print(datas)
            if rows.isEmpty {
                print("No data found.")
                return
            }
            
            completionHandler(datas)
            print("Number of rows in sheet: \(rows.count)")
        }
    }
    
    func getDataBBGoogleSheet(sheets: [String], completionHandler: @escaping ([MultilanguagePlistModel]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var datas: [MultilanguagePlistModel] = []
        for sheetName in sheets {
            dispatchGroup.enter()
            getDataFromBBGoogleSheet(sheetName: sheetName) { results in
                datas.append(contentsOf: results)
                dispatchGroup.leave()
            }
        }

        // 1
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            completionHandler(datas)
        })
    }
    
}

//read data
extension SyncLanguageVC {
    func readLocalizableFile() -> [MultilanguagePlistModel] {
        guard let pathen = (Bundle.main.path(forResource: appType.localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: LanguageKey.en.toKey)) else { return []}
        guard let pathSC = (Bundle.main.path(forResource: appType.localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: LanguageKey.sc.toKey)) else { return []}
        guard let pathTC = (Bundle.main.path(forResource: appType.localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: LanguageKey.tc.toKey)) else { return []}
        guard let pathVI = (Bundle.main.path(forResource: appType.localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: LanguageKey.vi.toKey)) else { return []}
        guard let pathThai = (Bundle.main.path(forResource: appType.localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: LanguageKey.thai.toKey)) else { return []}
        
        guard let dictEn = NSDictionary(contentsOfFile: pathen) as? [String: String] else { return []}
        guard let dictTC = NSDictionary(contentsOfFile: pathTC) as? [String: String] else { return []}
        guard let dictSC = NSDictionary(contentsOfFile: pathSC) as? [String: String] else { return []}
        guard let dictVI = NSDictionary(contentsOfFile: pathVI) as? [String: String] else { return []}
        guard let dictThai = NSDictionary(contentsOfFile: pathThai) as? [String: String] else { return []}
        
        var datas: [MultilanguagePlistModel] = []
        for key in dictEn.keys {
            let iosKey = key.trim
            let valueEN = dictEn[key]?.correctStringFromLocalize ?? ""
            let valueVN = dictVI[key]?.correctStringFromLocalize ?? valueEN
            let valueThai = dictThai[key]?.correctStringFromLocalize ?? valueEN
            let valueTC = dictTC[key]?.correctStringFromLocalize ?? valueEN
            let valueSC = dictSC[key]?.correctStringFromLocalize ?? valueEN
            let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: iosKey, tc: [valueTC], sc: [valueSC], en: [valueEN], vn: [valueVN], thai: [valueThai])
//            print(itemLang.printLanguage(language: .en))
            datas.append(itemLang)
        }
        datas = datas.sorted(by: { $0.iosKey < $1.iosKey })
        return datas
    }
}

//Write data
extension SyncLanguageVC {
    func writeNewData(language: LanguageKey = .en) {
        let resultData = localLanguages.map({$0.printLanguage(language: language)}).joined(separator: "\n")
        let filename = getDocumentsDirectory().appendingPathComponent("\(language.rawValue)_\(appType.localizableFileName).strings")
        print("filename:")
        print(filename)
        do {
            try resultData.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        var filesToShare = [Any]()

        // Add the path of the text file to the Array
        filesToShare.append(filename)

        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

extension SyncLanguageVC {
    func readInfoPlistFile() -> [MultilanguagePlistModel] {
        guard let pathen = Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "en") else { return []}
        guard let pathSC = Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "zh-Hans") else { return []}
        guard let pathTC = Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "zh-Hant") else { return []}
        guard let pathVI = Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "vi") else { return []}
        guard let pathThai = Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "th") else { return []}
        guard let dictEn = NSDictionary(contentsOfFile: pathen) as? [String: Any] else { return []}
        guard let dictTC = NSDictionary(contentsOfFile: pathTC) as? [String: Any] else { return []}
        guard let dictSC = NSDictionary(contentsOfFile: pathSC) as? [String: Any] else { return []}
        guard let dictVI = NSDictionary(contentsOfFile: pathVI) as? [String: Any] else { return []}
        guard let dictThai = NSDictionary(contentsOfFile: pathThai) as? [String: Any] else { return []}

        var datas: [MultilanguagePlistModel] = []
        for key in dictEn.keys {
            let iosKey = key.trim
            if var valueEN = dictEn[key] as? String {
                valueEN = valueEN.correctStringFromLocalize
                let valueVN = (dictVI[key] as? String)?.correctStringFromLocalize ?? valueEN
                let valueThai = (dictThai[key] as? String)?.correctStringFromLocalize ?? valueEN
                let valueTC = (dictTC[key] as? String)?.correctStringFromLocalize ?? valueEN
                let valueSC = (dictSC[key] as? String)?.correctStringFromLocalize ?? valueEN
                let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: iosKey, tc: [valueTC], sc: [valueSC], en: [valueEN], vn: [valueVN], thai: [valueThai])
                datas.append(itemLang)
            } else if var valueEN = dictEn[key] as? [String] {
                valueEN = valueEN.map({$0.correctStringFromLocalize})
                let valueVN = (dictVI[key] as? [String])?.map({$0.correctStringFromLocalize}) ?? valueEN
                let valueThai = (dictThai[key] as? [String])?.map({$0.correctStringFromLocalize}) ?? valueEN
                let valueTC = (dictTC[key] as? [String])?.map({$0.correctStringFromLocalize}) ?? valueEN
                let valueSC = (dictSC[key] as? [String])?.map({$0.correctStringFromLocalize}) ?? valueEN
                let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: iosKey, tc: valueTC, sc: valueSC, en: valueEN, vn: valueVN, thai: valueThai)
                datas.append(itemLang)
            }
        }
        datas = datas.sorted(by: { $0.iosKey < $1.iosKey })
        return datas
    }

}


//read dho google sheet
extension SyncLanguageVC {
    func getDataFromGoogleSheet(sheetName: String, completionHandler: @escaping ([MultilanguageModel]) -> Void) {
        var datas: [MultilanguageModel] = []
        let spreadsheetId = appType.spreadsheetId
//        let spreadsheetId = "1lCRrxpoW696Zo9w2Z0TCdLxh2spWg0-TpNWpdP3HkFA"
        let range = "\(sheetName)!A:H"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        
        sheetService.executeQuery(query) { (ticket, result, error) in
            if let error = error {
                print(error)
                completionHandler([])
                return
            }
            guard let result = result as? GTLRSheets_ValueRange else {
                return
            }
            
            let rows = result.values!
            let stringRows = (rows as! [[String]]).filter({!$0.isEmpty})
            var localizeStrings: [[String]] = []
            var arrStrings: [[[String]]] = []
            var isInArray = false
            var currentString = stringRows[1]
            var currentArray: [[String]] = []
            for index in 2..<stringRows.count {
                let row = stringRows[index]
                if row[0].isEmpty {
                    //array
                    if isInArray {
                        currentArray.append(row)
                    } else {
                        isInArray = true
                        currentArray.append(currentString)
                        currentArray.append(row)
                    }
                } else {
                    //localize only
                    if isInArray {
                        arrStrings.append(currentArray)
                        currentArray.removeAll()
                    } else {
                        localizeStrings.append(currentString)
                    }
                    currentString = row
                    isInArray = false
                }
            }
            if isInArray {
                arrStrings.append(currentArray)
            } else {
                localizeStrings.append(currentString)
            }
            
            let firstRow = stringRows[0]
            var indexKey = 0
            var startTC = 3
            if firstRow[0] == "String ID" {
                indexKey = 0
                startTC = 3
            } else if firstRow[1] == "String ID_IOS" || firstRow[1] == "iOS string ID" {
                indexKey = 1
                startTC = 4
            }
            for row in stringRows {
                if row.isEmpty { continue }
                print(row)
                let aosKey = row[indexKey].trimmingCharacters(in: .whitespacesAndNewlines)
                let iosKey = row[indexKey].trimmingCharacters(in: .whitespacesAndNewlines)
                if iosKey.isEmpty {
                    continue
                }
                let tc = row[startTC]
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let sc = row[startTC+1]
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let en = row[startTC+2]
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let vn = row[startTC+3]
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
//                let itemLang = MultilanguageModel(iosKey: iosKey, aosKey: aosKey, tc: tc, sc: sc, en: en, vn: vn)
//                print(itemLang.printLanguage(language: .en))
//                datas.append(itemLang)
            }
//            print(datas)
            if rows.isEmpty {
                print("No data found.")
                return
            }
            
            completionHandler(datas)
            print("Number of rows in sheet: \(rows.count)")
        }
    }
    
    func getDataGoogleSheet(sheets: [String], completionHandler: @escaping ([MultilanguageModel]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var datas: [MultilanguageModel] = []
        for sheetName in sheets {
            dispatchGroup.enter()
            getDataFromGoogleSheet(sheetName: sheetName) { results in
                datas.append(contentsOf: results)
                dispatchGroup.leave()
            }
        }

        // 1
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            completionHandler(datas)
        })
    }
    
}

