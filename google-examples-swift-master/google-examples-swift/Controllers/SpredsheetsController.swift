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

class MultilanguagePlistModel {
    var iosKey: String
    var aosKey: String
    var tc: [String]
    var sc: [String]
    var en: [String]
    var vn: [String]
    
    init(iosKey: String, aosKey: String, tc: [String], sc: [String], en: [String], vn: [String]) {
        self.iosKey = iosKey
        self.aosKey = aosKey
        self.tc = tc
        self.sc = sc
        self.en = en
        self.vn = vn
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
            case .vn:
                values = vn
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
            case .vn:
                return "\"\(key)\" = \"\(vn[0])\";"
            }
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
    var isMemberApp = true
    var localizableFileName = "Localizable"
    var localLanguage: [MultilanguageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetService.apiKey = K.apiKey
        sheetService.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        
        driveService.apiKey = K.apiKey
        driveService.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        
        isMemberApp = true
        localizableFileName = isMemberApp ? "MemLocalizable" : "Localizable"

//        readLocalizableFileToArray(language: .en)
//        return
//        localLanguage = readLocalizableFile()
//        writeNewData()

        readInfoPlistFile()
        
//        isMemberApp ? updateMemberData() : updateExpertData()
        getDataFromGoogleSheet(sheetName: "MB_Smart Clinic") { results in

        }
        
    }
    func updateMemberData() {
        let keysUpdate: [String] = [
            "STR_MSG_CODE_902",
            "STR_MSG_CODE_904",
            "STR_MSG_CODE_906",
            "STR_MSG_CODE_909",
            "STR_MSG_CODE_912",
            "STR_MSG_CODE_913",
            "STR_MSG_CODE_915",
            "STR_MSG_CODE_916",
            "STR_MSG_CODE_918",
            "STR_MSG_CODE_941",
            "STR_MSG_CODE_943",
            "STR_MSG_CODE_956",
            "STR_MSG_CODE_1121",
            "STR_ERROR_VALD_1004",
            "STR_ERROR_VALD_1005",
            "STR_ERROR_VALD_1006",
            "STR_ERROR_VALD_1007",
            "STR_ERROR_VALD_1016",
            "STR_ERROR_VALD_1018",
            "STR_ERROR_VALD_1019",
            "STR_EXAMDATA_ACTVITY_GENERALDATA_IS_NOT_COMPLETE",
            "STR_SETING_ACTIVITY_AUDIO_MODE_HINT",
            "STR_EDITPROFILE_TOAST_REMIND_SAVE_PROFILE",
            "STR_EDITPROFILE_ACTIVITY_CHANGE_AVATAR_FAILED",
            "STR_CHAT_DOCTOR_ACTIVITY_LOAD_MEMBER_PROFILE_FAILED",
            "STR_MAIN_ACTIVITY_CHANGE_HIDING_DOCTOR_STATUS_FAILED",
            "STR_YOU_MUST_CHOOSE_AT_LEAST_ONE",
            "STR_TOAST_WRONG_PHONE_FORMAT",
            "STR_EXAM_ACTIVITY_PLEASE_FILL",
            "STR_TOAST_CHECK_EMAIL_GET_PASSWORD",
            "STR_TOAST_MESSAGE_NOT_ENOUGH_MEMORY",
            "STR_TOAST_LOAD_IMAGE_FAIL",
            "STR_TOAST_PRESS_BACK_BUTTON",
            "STR_CONTENT_DIALOG_WHEN_LOGIN_FREEPP_FAILED",
            "STR_NAME_RULE",
            "STR_NAME_LENGTH_RULE",
            "STR_DR_HEREONLINE_SERVICE_CANNOT_BE_ACCESSED_TRY_AGAIN",
            "STR_QR_CODE_SAVED_TO_ALBUM",
            "STR_IMAGE_SAVED_TO_ALBUM",
            "STR_MS_CARING_UNREAD_MESSAGES",
            "STR_FORGOT_PASSWORD_ACTIVITY_GUIDE",
            "STR_AFTER_HIDING_GO_TO_MORE_SCREEN_TO_CHECK_MESSAGE",
            "STR_MOBILE_NUMBER_IS_TOO_LONG",
            "STR_PHONE_NUMBER_IS_TOO_LONG",
            "STR_INVITESHARE_DOCTOR_ACTIVITY_THIS_PERSON_EXIST_IN_YOUR_LIST",
            "STR_LC_GLS_YOUR_POINT_BALANCE_IS_NOT_ENOUGH",
            "STR_LC_GLS_YES_I_WOULD_LIKE_TO_SUBSCRIBE",
            "STR_LC_PLEASE_INPUT_PHONE_OR_MOBILE",
            "STR_INVITESHARE_CANNOT_SHARE_BECAUSE_IS_DUE",
            "STR_GLS_INFOR_DISCONECT_GLUCOSE",
            "STRING_MEASURE_INCORRECT_VALUES",
            "STR_SPLASH_ACTIVITY_COPYRIGHT",
            "STR_EXAM_ACTIVITY_HOSPITAL_NAME_AND_DATE_NOT_EMPTY",
            "STR_CHOOSE_AREA_GROUP_DEVELOPING",
            "STR_COMPARE_EXAM_TOAST_AT_LEAST_TWO_EXAM_DATA_IS_REQUIRED_TO_PROCEED_COMPARISON",
            "STR_MESSAGE_SEEN",
            "STR_SIZE_IMAGE_CROP_SEND",
            "STR_ARE_YOU_SURE_STOP_CROPPING_IMAGE",
            "STR_HEALTH_NOTIFICATION_SETTING",
            "STR_ABNORMAL_VALUES_FOLLOW_UP_SETTING",
            "STR_NEXT_RETURN_DATE_MUST_BE_FUTURE_TIME",
            "STR_HNS_NOTE_FOLLOW_UP_CURRENT",
            "STR_HNSB_HEALTH_FU_NOTIFICATION",
            "STR_FILTER_BY_FOLLOW_UP",
            "STR_NO_ABNORMAL_VALUES_FOLLOW_UP_CURRENTLY",
            "STR_USER_DEFINED_SETTING",
            "STR_ADD_USER_DEFINED",
            "STRING_INPUT_F_U_NAME",
            "STR_MSG_CODE_974",
            "STR_MSG_CODE_981",
            "STR_SIGN_UP_BY_EMAIL",
            "STR_REGISTER_BY_PHONE_NUMBER",
            "STR_SIGN_UP_BY_MOBILE_NUMBER",
            "STR_WRONG_VERIFICATION_CODE",
            "STR_PLEASE_ENTER_YOUR_EMAIL_OR_MOBILE_NUMBER_FINISH_THIS_PROCESS",
            "STR_CHECK_MOBILE_GET_PASSWORD",
            "STR_GUIDE_AFTER_CHANGE_MOBILE",
            "STR_CORPORATE_MESSAGE_GET_INFOMATION_FAILED",
            "STR_CORPORATE_NURSE_MESSAGE_GET_INFOMATION_FAILED",
            "STR_PLEASE_CHECK_YOUR_EMAIL_TO_GET_THE_CODE_FOR_VALIDATION",
            "STR_YOUR_MAIL_ACCOUNT_WAS_CHANGED_SUCCESSFULLY_PLEASE_SIGN_IN_AS_NEW_EMAIL_ACCOUNT",
            "STR_YOUR_ACCOUNT_HAS_BEEN_CHANGED_RECENTLY_PLEASE_USE_YOUR_NEW_ACCOUNT_TO_SIGN_IN",
            "STR_WEIGHT_ALARM_MESSAGE",
            "STR_SEARCH_SHARELIST_BMI_NONE_ACCOUNT",
            "STR_DO_ALARM_SETTING_REMIND_TIME_TO_WEIGH",
            "STR_DO_ALARM_SETTING_REMIND_TIME_TO_MEASURE_TEMPERATURE",
            "STR_TEMPERATURE_ALARM_MESSAGE",
            "STR_SEARCH_SHARELIST_TEMPERATURE_NONE_ACCOUNT",
            "STR_INPUT_PEAK_EXPIRATORY_FLOW_RATE",
            "STR_PEAK_EXPIRATORY_FLOW_RATE_PEF",
            "STR_YELLOWLIGHT_SHOWS_THAT_ASTHMA_CONTROL_IS_UNSTABLE_AND_MUST_BE_ALERT",
            "STR_REDLIGHT_PRESENTS_ASTHMA_EXACERBATED_AND_MUST_BE_CONTROLLED_IMMEDIATELY",
            "STR_SEARCH_SHARELIST_PFM_NONE_ACCOUNT",
            "STR_DO_ALARM_SETTING_REMIND_TIME_TO_MEASURE_PEAK_EXPIRATORY_FLOW_RATE",
            "STR_PFM_ALARM_MESSAGE",
            "STR_BACK_UP_GOOGLE_DRIVE_CAN_RESTORE_WHEN_REINSTALL_APP",
            "STR_WARNING_BACKUP_ACCOUNT_NOT_FOUND_ADD_A_BACKUP_ACCOUNT",
            "STR_DATA_BACKING_UP_HELP_STORE_PRIVATELY_CONVIENTLY_SAFELY",
            "STR_GRANT_DRHEREONLINE_PERMISSION_VIEW_MANAGE_DATA_GOOGLE_DRIVE",
            "STR_DO_YOU_NEED_INVOICE",
            "STR_OCR_DEVICE_VALUE_CANNOT_RECOGNIZED",
            "STR_ABNORMAL",
            "STR_BLOOD_OXYGEN_VALUE_ALARMING",
            "STR_BLOOD_OXYGEN_VALUE_LOW",
            "STR_BLOOD_OXYGEN_VALUE_SLIGHTLY_LOWER_THAN_NORMAL",
            "STR_BLOOD_OXYGEN_VALUE_NORMAL"
        ]
        let sheets = [
            "MB_Message",
            "MB_Ms.Caring",
            "MB_Forgot Password",
            "MB_Main",
            "MB_Profile",
            "MB_Share LifeCare",
            "MB_Glucose Subscription",
//            "MB_Glucose B",
            "Blood Pressure Measurement",
            "MB_More",
            "MB_Exam",
            "MB_Chat",
            "MB_HNS_B",
            "MB_HNS_C",
            "MB_HNS_E",
            "MB_SMS",
            "MB_Corporate",
            "MB_Change Email Code",
            "Weight_Management",
            "Temperature_Management",
            "Pulmonary Function",
            "Back_up_and_Restore",
            "VIP_membership",
            "OCR",
            "Blood_Oxygen"
        ]
        updateData(keysUpdate: keysUpdate, sheets: sheets)
    }
    func updateExpertData() {
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
        updateData(keysUpdate: keysUpdate, sheets: sheets)
    }
    
    func updateData(keysUpdate: [String], sheets: [String]) {
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
                    print("warning key not found: \"\(key)\"")
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
    
    func readInfoPlistFile() -> [MultilanguagePlistModel] {
        
        let pathen = (Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "en"))
        let pathSC = (Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "zh-Hans"))
        let pathTC = (Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "zh-Hant"))
        let pathVI = (Bundle.main.path(forResource: "InfoPlist", ofType: "strings", inDirectory: nil, forLocalization: "vi"))

        let dictEn = NSDictionary(contentsOfFile: pathen!)
        let dictTC = NSDictionary(contentsOfFile: pathTC!)
        let dictSC = NSDictionary(contentsOfFile: pathSC!)
        let dictVI = NSDictionary(contentsOfFile: pathVI!)

        var datas: [MultilanguagePlistModel] = []
        for (key, value) in dictEn! {
            if var iosKey = key as? String {
                iosKey = iosKey.trimmingCharacters(in: .whitespacesAndNewlines)
                if var valueEn = value as? String {
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
                    let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: iosKey, tc: [valueTC], sc: [valueSC], en: [valueEn], vn: [valueVN])
                    print(itemLang.printLanguage(language: .en))
                    datas.append(itemLang)
                } else if var valueEn = value as? [String],
                          var valueTC = dictTC?[key] as? [String],
                          var valueSC = dictSC?[key] as? [String],
                          var valueVN = dictVI?[key] as? [String]{
                    valueEn = valueEn.map({
                        $0.replacingOccurrences(of: "\\", with: "\\\\")
                            .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")})
                    valueTC = valueTC.map({
                        $0.replacingOccurrences(of: "\\", with: "\\\\")
                            .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")})
                    valueSC = valueSC.map({
                        $0.replacingOccurrences(of: "\\", with: "\\\\")
                            .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")})
                    valueVN = valueVN.map({
                        $0.replacingOccurrences(of: "\\", with: "\\\\")
                            .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\"", with: "\\\"")})
                    let itemLang = MultilanguagePlistModel(iosKey: iosKey, aosKey: iosKey, tc: valueTC, sc: valueSC,
                                                           en: valueEn,
                                                           vn: valueVN)
                    print(itemLang.printLanguage(language: .en))
                    datas.append(itemLang)
                    
                }
            }
        }
        datas = datas.sorted(by: { $0.iosKey < $1.iosKey })
        return datas
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
            if var iosKey = key as? String,
               var valueEn = value as? String {
                iosKey = iosKey.trimmingCharacters(in: .whitespacesAndNewlines)
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
        let spreadsheetId = isMemberApp ? "1FeMzrRgLeA_s2gv0Es-Cvy4yiJ0sYdgCdh5BRMUnSM4" : "1l7HZfeKCR9OJuxoYplOB5jLOWV0nyv0RApGsBAKqrqo"
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
