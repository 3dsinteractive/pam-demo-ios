//
//  Pam.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 2/3/2564 BE.
//

import UIKit
import UserNotifications

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

struct PamConfig: Codable {
    var pamServer: String
    let publicDBAlias: String
    let loginDBAlias: String

    enum CodingKeys: String, CodingKey {
        case pamServer = "pam-server"
        case publicDBAlias = "public-db-alias"
        case loginDBAlias = "login-db-alias"
    }
}


class Pam{
    
    private static var config: PamConfig?
    private static var custID: String?
    private static var contactID:String?
    private static var isEnableLog = false
    
    static func enableLog(){
        isEnableLog = true
    }
    
    static func initialize() throws {
        if let filepath = Bundle.main.path(forResource: "pam-config", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                Pam.config = try JSONDecoder().decode(PamConfig.self, from: contents.data(using: .utf8)!)
                if Pam.config?.pamServer.hasSuffix("/") ?? false {
                    Pam.config?.pamServer.removeLast()
                }
                
                if isEnableLog {
                    print("🦄 PAM :  initialize pamServer =", Pam.config?.pamServer ?? "")
                    print("🦄 PAM :  initialize loginDBAlias =", Pam.config?.loginDBAlias ?? "")
                    print("🦄 PAM :  initialize publicDBAlias =", Pam.config?.publicDBAlias ?? "")
                }
            } catch {
                throw RuntimeError("PAM Error!! Invalid JSON Format 'pam-config.json' \(error)")
            }
        } else {
            throw RuntimeError("PAM Error!! File not found 'pam-config.json'")
        }
    }
    
    static func askNotificationPermission(mediaAlias: String, options: UNAuthorizationOptions){
        if isEnableLog {
            print("🦄 PAM :  askNotificationPermission")
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                if isEnableLog {
                    print("🦄 PAM :  askNotificationPermission", error)
                }
            }else{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    static func track(event:String, payload: [String:Any]? = nil){
        let url = (Pam.config?.pamServer ?? "") + "/trackers/events"
        
        var body:[String:Any] = [
            "event":event,
            "platform": "iOS",
            "os_version": Pam.osVersion,
            "app_version": Pam.versionBuild,
            "form_fields": []
        ]
        
        var formField:[String:Any] = [:]
        
        if contactID == nil {
            if let contact = readValue(key: "contact_id") {
                contactID = contact
                formField["_contact_id"] = contactID
            }
        }else{
            formField["_contact_id"] = contactID
        }
        
        payload?.forEach{
            formField[$0.key] = $0.value
        }
        
        if Pam.custID == nil {
            formField["_database"] = Pam.config?.publicDBAlias ?? ""
        }else{
            formField["_database"] = Pam.config?.loginDBAlias ?? ""
        }
        
        body["form_fields"] = formField
        
        if isEnableLog {
            if let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) {
                print("🦄 PAM :  Post Tracking Event=\(event) payload=", String(data: bodyData, encoding: .utf8) ?? "nil")
            }
        }
            
        HttpClient.post(url: url, queryString: nil, headers: nil, json: payload){
            if let contactID = $0?["contact_id"] as? String{
                
                if isEnableLog {
                    print("🦄 PAM :  Received Contact ID=", contactID)
                }
                
                let oldContactID = self.contactID ?? "-"
                if oldContactID != contactID {
                    self.contactID = contactID
                    saveValue(value: "contact_id", key: contactID)
                    if isEnableLog {
                        print("🦄 PAM :  Replace Old Contact ID='\(oldContactID)' with new contact ID='\(contactID)'")
                    }
                }
            }
        }
    }
    
    static func userLogin(custID: String){
        
        if isEnableLog {
            print("🦄 PAM :  Login customer ID=\(custID)")
        }
        
        saveValue(value:custID, key: "cust_id")
        Pam.custID = custID
        let payLoad = [
            "customer": custID
        ]
        Pam.track(event: "login", payload: payLoad)
    }
    
    static func userLogout(){
        if isEnableLog {
            print("🦄 PAM :  Logout")
        }
        custID  = nil
        removeValue(key: "cust_id")
        Pam.track(event: "logout")
    }
    
    static func setPushNotification(userInfo:[AnyHashable : Any], completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool{
        //if let info = userInfo["pam"] {
            completionHandler(.newData)
            return true
        //}
        //return false
    }
    
    private static func saveValue(value: String, key: String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    private static func readValue(key: String)-> String?{
        return UserDefaults.standard.string(forKey: key)
    }
    
    private static func removeValue(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func setDeviceToken(deviceToken:Data) -> String{
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        #if DEBUG
        let saveToken = "_" + token
        #else
        let saveToken = token
        #endif
        
        Pam.track(event: "save_push", payload: ["ios_notification":saveToken])
        
        if isEnableLog {
            print("🦄 PAM :  Save Push Notification Token=\(saveToken)")
        }
        
        return token
    }
}


class HttpClient {
    typealias OnSuccess = ([String: Any]?)->Void
    
    static func post(url:String, queryString: [String:String]?, headers:[String:String]?, json: [String: Any]?, onSuccess: OnSuccess?){
        guard var url = URLComponents(string: url) else {return}
        url.queryItems = []
        queryString?.forEach{
            url.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        guard let reqURL = url.url else{return}

        var request = URLRequest(url: reqURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        headers?.forEach{
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let json = json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error == nil, let data = data{
                let resultDictionay = try? JSONSerialization.jsonObject(with: data, options: []) as?  [String: Any]
                onSuccess?(resultDictionay)
            }
        }.resume()
        
    }
    
}

extension Pam {

    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    static var versionBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    static var osVersion: String {
        let version = ProcessInfo().operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
}
