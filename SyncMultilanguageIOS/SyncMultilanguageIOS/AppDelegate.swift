//
//  AppDelegate.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import UIKit
import GoogleSignIn
import Firebase
import CoreData
import SOFCommons

public protocol SOFBankAccountBaseInfo {
    var sofBankAccountName: String { get }
    var sofBankAccountNumber: String { get }
    func capA()
}
public protocol SOFCumulativeAccount: SOFBankAccountBaseInfo {
    var sofTerm: String { get }
    func capB()

}

public protocol SOFLoanAccount: SOFBankAccountBaseInfo {
    var sofTerm: String { get }
    var sofInterested: String { get }
    func capB()
}

public struct SOFBankAccount {
    var textString: String
}
extension SOFBankAccount: SOFCumulativeAccount {
    public var sofTerm: String {
        return textString
    }
    
    public func capB() {
        print("capB")
    }
    
    public var sofBankAccountName: String {
        return textString
    }
    
    public var sofBankAccountNumber: String {
        return textString
    }
    
    public func capA() {
        print("capA")
    }
}
extension SOFBankAccount: SOFLoanAccount {
    public var sofInterested: String {
        return textString
    }
}

typealias SOFBankAccountInterface = SOFLoanAccount & SOFCumulativeAccount

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let signInConfig = GIDConfiguration.init(clientID: Constants.clientID)
    var account: SOFBankAccountInterface?
    var loanAccount: SOFCumulativeAccount?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
            } else {
                print("Previous sign in restored!")
            }
        }
        
        let test = "hello \n b"
        let rsss = test.correctStringFromGoogleSheetIOS
        debugPrint(rsss)
        
        let item = "Constants.additionalScopes".isFormatCurrencyCorrect
        FirebaseApp.configure()
        account = SOFBankAccount(textString: "Dat")
        print(account?.sofInterested)
        print(account?.sofTerm)
        print(account?.sofBankAccountName)
        print(account?.capB)
        startViewController()
        
        loanAccount = account
        
        print(loanAccount?.sofTerm)
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        return false
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        
        if handled {
            return true
        }
        // Handle other custom URL types.
        // If not handled by this app, return false.
        return false
    }
    

    
}

extension AppDelegate {
    func startViewController() {
        let pVC = SyncLanguageVC(nibName: nil, bundle: nil)
        let navController = UINavigationController(rootViewController: pVC)
        // create a basic UIWindow and activate it
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .clear
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
    }
}
