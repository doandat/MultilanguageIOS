//
//  SpredsheetsController.swift
//  google-examples-swift
//
//  Created by Milan Parađina on 07.02.2021..
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

enum LanguageKey: String {
    case tc
    case sc
    case en
    case vn
    
    var toKey: String {
        switch self {
        case .tc:
            return "zh-Hant"
        case .sc:
            return "zh-Hans"
        case .en:
            return "en"
        case .vn:
            return "vi"
        }
    }
}

class MultilanguageModel {
    var iosKey: String
    var aosKey: String
    var tc: String
    var sc: String
    var en: String
    var vn: String
    
    init(iosKey: String, aosKey: String, tc: String, sc: String, en: String, vn: String) {
        self.iosKey = iosKey
        self.aosKey = aosKey
        self.tc = tc
        self.sc = sc
        self.en = en
        self.vn = vn
    }
    
    func printLanguage(isIOS: Bool = true, language: LanguageKey) -> String {
        let key = isIOS ? iosKey : aosKey
        switch language {
        case .tc:
            return "\"\(key)\" = \"\(tc)\";"
        case .sc:
            return "\"\(key)\" = \"\(sc)\";"
        case .en:
            return "\"\(key)\" = \"\(en)\";"
        case .vn:
            return "\"\(key)\" = \"\(vn)\";"
        }
    }
    
}

class SpredsheetsController: UIViewController {
    
    //Test spreadsheet: https://docs.google.com/spreadsheets/d/1Nm9NvZ0TOa_ifFTo7YSn1EG3eVg1O32m7QrsVeorMQQ/edit?usp=sharing
    let utils = Utils()
    let sheetService = GTLRSheetsService()
    let driveService = GTLRDriveService()
    var localizableFileName = "Localizable"
    var localLanguage: [MultilanguageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetService.apiKey = K.apiKey
        sheetService.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        
        driveService.apiKey = K.apiKey
        driveService.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        
        let isMemberApp = true
        localizableFileName = isMemberApp ? "MemLocalizable" : "Localizable"

//        readLocalizableFileToArray(language: .en)
//        return
        localLanguage = readLocalizableFile()
//        writeNewData()

//        updateData()
    }

    func updateData() {
        let keysUpdate: [String] = [
            "STR_APPLICATION_FORM_ACTIVITY_DIALOG_NON_APPROVED",
            "STR_MESSAGE_SEEN",
            "STR_ABOUT_ACTIVITY_COPY_RIGHT",
            "STR_CHANG_EMAIL",
            "STR_INSERT_ALL_FIELDS",
            "STR_CHANGEEMAIL_ACTIVITY_EMAIL_IS_REQUIRED",
            "STR_CHANGEEMAIL_ACTIVITY_PASSWORD_IS_REQUIRED",
            "STR_PLEASE_LEAVE_YOUR_CONTACT_INFORMATION_CUSTOMER_SERVICE_STAFF_WILL_CONTACT_WITH_YOU",
            "STR_NEW_SCHEDULE_CONFLICT_EXISTED_SCHEDULE",
            "STR_NUMBER_OF_USERS_LATEST_BLOOD_GLUCOSE_ABNORMAL",
            "STR_NUMBER_OF_USERS_NOT_MEASURED_BLOOD_GLUCOSE_FOR_HOURS",
            "STR_NUMBER_OF_USERS_LATEST_BLOOD_PRESSURE_ABNORMAL",
            "STR_NUMBER_OF_USERS_NOT_MEASURED_BLOOD_PRESSURE_FOR_HOURS",
            "STR_MINS_AGO",
            "STR_SELECT_USERS_TO_BROADCAST",
            "STR_SET_UP_THE_RETURN_DATE_FOR_MEMBER",
            "STR_SET_UP_INTERVAL_REWEIGH",
            "STR_NUMBER_OF_USERS_NOT_REWEIGH_FOR_HOURS",
            "STR_NUMBER_OF_USERS_LATEST_WEIGHT_ABNORMAL",
            "STR_SET_UP_INTERVAL_MEASURE_TEMPERATURE",
            "STR_NUMBER_OF_USERS_NOT_MEASURE_TEMPERATURE_FOR_HOURS",
            "STR_NUMBER_OF_USERS_LATEST_TEMPERATURE_ABNORMAL",
            "STR_SET_UP_INTERVAL_MEASURE_PEFR",
            "STR_NUMBER_OF_USERS_LATEST_PEFR_ABNORMAL",
            "STR_DATA_BACKING_UP_HELP_STORE_PRIVATELY_CONVIENTLY_SAFELY",
            "STR_MESSAGES_BACK_UP_SUCCESSFULLY",
            "STR_MESSAGES_RESTORE_SUCCESSFULLY",
            "STR_BLOOD_OXYGEN_VALUE_ALARMING",
            "STR_BLOOD_OXYGEN_VALUE_LOW",
            "STR_BLOOD_OXYGEN_VALUE_SLIGHTLY_LOWER_THAN_NORMAL",
            "STR_SET_UP_INTERVAL_MEASURE_BLOOD_OXYGEN"
        ]
        let sheets = [
            "DC_SignUp",
            "DC_Chat",
            "DC_More",
            "DC_ChangeEmail",
            "DC_Smart CLinic Registration Fo",
            "Service Status Schedule",
            "LifeCare_Improvement",
            "Return Date Setting",
            "Weight_Management",
            " Temperature_Management",
            "Pulmonary_Function",
            "Back_up_and_Restore",
            "Blood_Oxygen"
//            "DC_Profile",
            
        ]
        getDataGoogleSheet(sheets: sheets) {[weak self] results in
            guard let self else { return }
            print("Done getDataGoogleSheet")
            for key in keysUpdate {
                if let itemInSheet = results.first(where: {$0.iosKey == key}),
                    let itemLocal = self.localLanguage.first(where: {$0.iosKey == key}) {
                    itemLocal.en = itemInSheet.en
                    itemLocal.sc = itemInSheet.sc
                    itemLocal.tc = itemInSheet.tc
                    itemLocal.vn = itemInSheet.vn
                } else {
                    print("warning key not found: \(key)")
                }
            }
            self.writeNewData()
            
        }
    }
    
    func writeNewData(language: LanguageKey = .en) {
        let resultData = localLanguage.map({$0.printLanguage(language: language)}).joined(separator: "\n")
        let filename = getDocumentsDirectory().appendingPathComponent("\(language.rawValue)_\(localizableFileName).strings")

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

    
    @IBAction func appendDataPressed(_ sender: UIButton) {
        appendData { (string) in
            self.utils.showAlert(title: "", message: string, vc: self)
        }
    }
    
    @IBAction func specificCellPressed(_ sender: UIButton) {
        sendDataToCell { (string) in
            self.utils.showAlert(title: "", message: string, vc: self)
        }
    }
    
    @IBAction func readDataPressed(_ sender: UIButton) {
        readData { (string) in
//            self.utils.showAlert(title: "", message: string, vc: self)
        }
    }
    
    @IBAction func readSheetsPressed(_ sender: Any) {
        readSheets { (string) in
            self.utils.showAlert(title: "", message: string, vc: self)
        }
    }
    
    @IBAction func languageEng(_ sender: Any) {
        writeNewData(language: .en)
    }
    
    @IBAction func languageSC(_ sender: Any) {
        writeNewData(language: .sc)
    }
    
    @IBAction func languageTC(_ sender: Any) {
        writeNewData(language: .tc)
    }
    
    @IBAction func languageVN(_ sender: Any) {
        writeNewData(language: .vn)
    }
}

extension SpredsheetsController {
    //MARK: Spreadsheets methods
    func appendData(completionHandler: @escaping (String) -> Void) {

        let spreadsheetId = K.sheetID
        let range = "A1:Q"
        let rangeToAppend = GTLRSheets_ValueRange.init();
        let data = ["this", "is","a","test"]
        
        rangeToAppend.values = [data]
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: rangeToAppend, spreadsheetId: spreadsheetId, range: range)
            query.valueInputOption = "USER_ENTERED"
        
            sheetService.executeQuery(query) { (ticket, result, error) in
                if let error = error {
                    print("Error in appending data: \(error)")
                    completionHandler("Error in sending data:\n\(error.localizedDescription)")
                } else {
                    print("Data sent: \(data)")
                    completionHandler("Success!")
                }
            }
        }
    
    func sendDataToCell(completionHandler: @escaping (String) -> Void) {
            
            let spreadsheetId = K.sheetID
            let currentRange = "A5:B5" //Any range on the sheet, for instance: A5:B6
            let results = ["this is a test"]
            let rangeToAppend = GTLRSheets_ValueRange.init();
                rangeToAppend.values = [results]
        
            let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: rangeToAppend, spreadsheetId: spreadsheetId, range: currentRange)
                query.valueInputOption = "USER_ENTERED"
        
                sheetService.executeQuery(query) { (ticket, result, error) in
                    if let error = error {
                        print(error)
                        completionHandler("Error in sending data:\n\(error.localizedDescription)")
                    } else {
                        print("Sending: \(results)")
                        completionHandler("Sucess!")
                    }
                }
    }
    
    func readLocalizableFileToArray(language: LanguageKey = .en) {
//        pathen = (Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: "en"))
//        let file = Bundle.main.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "en")
        guard let pathen = Bundle.main.url(forResource: localizableFileName, withExtension: "strings", subdirectory: nil, localization: language.toKey) else { return }
        do {
            let textContent = try String(contentsOf: pathen, encoding: .utf8)
            let lines = textContent.components(separatedBy: .newlines)
            var itemkeys: [String] = []
            for line in lines {
                var newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if newLine.isEmpty { continue }
                let langItem = newLine.components(separatedBy: "=").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                let langkey = langItem[0]
                let langvalue = langItem[1]
//                print(langkey)
//                print(langvalue)
                if let itemFind = itemkeys.first(where: {$0 == langkey}) {
                    print("duplicate key: \(itemFind)")
                } else {
                    itemkeys.append(langkey)
                }
            }

        }
        catch {
            print("User creation failed with error: \(error)")
            
        }
    }
    
    func readLocalizableFile() -> [MultilanguageModel] {
        let pathen = (Bundle.main.path(forResource: localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: "en"))
        let pathSC = (Bundle.main.path(forResource: localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: "zh-Hans"))
        let pathTC = (Bundle.main.path(forResource: localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: "zh-Hant"))
        let pathVI = (Bundle.main.path(forResource: localizableFileName, ofType: "strings", inDirectory: nil, forLocalization: "vi"))
        let dictEn = NSDictionary(contentsOfFile: pathen!)
        let dictTC = NSDictionary(contentsOfFile: pathTC!)
        let dictSC = NSDictionary(contentsOfFile: pathSC!)
        let dictVI = NSDictionary(contentsOfFile: pathVI!)
        var datas: [MultilanguageModel] = []
        for (key, value) in dictEn! {
            if let iosKey = key as? String,
               var valueEn = value as? String {
                var valueTC = ""
                var valueSC = ""
                var valueVN = ""
                if let keyVal = dictTC?[key] as? String {
                    valueTC = keyVal
                        .replacingOccurrences(of: "\\", with: "\\\\")
                        .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")
                }

                if let keyVal = dictSC?[key] as? String {
                    valueSC = keyVal
                        .replacingOccurrences(of: "\\", with: "\\\\")
                        .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")
                }
                
                if let keyVal = dictVI?[key] as? String {
                    valueVN = keyVal
                        .replacingOccurrences(of: "\\", with: "\\\\")
                        .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")
                }
                valueEn = valueEn
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\n", with: "\\n")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                let itemLang = MultilanguageModel(iosKey: iosKey, aosKey: iosKey, tc: valueTC, sc: valueSC,
                                                  en: valueEn,
                                                  vn: valueVN)
//                print(itemLang.printLanguage(language: .en))
                datas.append(itemLang)
            }
            
        }
        datas = datas.sorted(by: { $0.iosKey < $1.iosKey })
        return datas
    }
    
    func getDataFromGoogleSheet(sheetName: String, completionHandler: @escaping ([MultilanguageModel]) -> Void) {
        var datas: [MultilanguageModel] = []
        let spreadsheetId = "1l7HZfeKCR9OJuxoYplOB5jLOWV0nyv0RApGsBAKqrqo" //doctor liao
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
            let stringRows = rows as! [[String]]
            let firstRow = stringRows[0]
            var indexKey = 0
            var startTC = 3
            if firstRow[0] == "String ID" {
                indexKey = 0
                startTC = 3
            } else if firstRow[1] == "String ID_IOS" {
                indexKey = 1
                startTC = 4
            }
            for row in stringRows {
//                print(row)
                let aosKey = row[indexKey].trimmingCharacters(in: .whitespacesAndNewlines)
                let iosKey = row[indexKey].trimmingCharacters(in: .whitespacesAndNewlines)
                if iosKey.isEmpty {
                    continue
                }
                let tc = row[startTC]
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let sc = row[startTC+1]
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let en = row[startTC+2]
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let vn = row[startTC+3]
                    .replacingOccurrences(of: "%d", with: "%@")
                    .replacingOccurrences(of: "%s", with: "%@")
                    .replacingOccurrences(of: "%f", with: "%@")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let itemLang = MultilanguageModel(iosKey: iosKey, aosKey: aosKey, tc: tc, sc: sc, en: en, vn: vn)
//                print(itemLang.printLanguage(language: .en))
                datas.append(itemLang)
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
    
    func readData(completionHandler: @escaping ([MultilanguageModel]) -> Void) {
        print("Getting sheet data...")
        
    }
    
    func readSheets(completionHandler: @escaping (String) -> Void ) {
        print("func findSpreadNameAndSheets executing...")
        
        let spreadsheetId = K.sheetID
        let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: spreadsheetId)
        
        sheetService.executeQuery(query) { (ticket, result, error) in
            if let error = error {
                print(error)
                completionHandler("Error in loading sheets\n\(error.localizedDescription)")
            } else {
                let result = result as? GTLRSheets_Spreadsheet
                let sheets = result?.sheets
                if let sheetInfo = sheets {
                    for info in sheetInfo {
                            print("New sheet found: \(String(describing: info.properties?.title))")
                        }
                    }
                completionHandler("Success!")
            }
        }
    }
}
