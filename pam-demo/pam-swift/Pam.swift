//
//  swift
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


class Pam: NSObject{
    
    public static var shared = Pam()
    
    private var config: PamConfig?
    private var custID: String?
    private var contactID:String?
    private var isEnableLog = false
    
    typealias ListenerCallBack = ([AnyHashable: Any])->Void
    
    private var onToken:[ListenerCallBack] = []
    private var onMessage:[ListenerCallBack] = []
    private var onConsent:[ListenerCallBack] = []
    
    private var pendingNotification:[[AnyHashable : Any]] = []
    private var isAppReady = false
    
    func initialize(launchOptions:[UIApplication.LaunchOptionsKey: Any]?, enableLog: Bool = false ) throws {
        
        isEnableLog = enableLog
        
        if let filepath = Bundle.main.path(forResource: "pam-config", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                config = try JSONDecoder().decode(PamConfig.self, from: contents.data(using: .utf8)!)
                if config?.pamServer.hasSuffix("/") ?? false {
                    config?.pamServer.removeLast()
                }
                
                if isEnableLog {
                    print("🦄 PAM :  initialize pamServer =", config?.pamServer ?? "")
                    print("🦄 PAM :  initialize loginDBAlias =", config?.loginDBAlias ?? "")
                    print("🦄 PAM :  initialize publicDBAlias =", config?.publicDBAlias ?? "")
                }
            } catch {
                throw RuntimeError("PAM Error!! Invalid JSON Format 'pam-config.json' \(error)")
            }
        } else {
            throw RuntimeError("PAM Error!! File not found 'pam-config.json'")
        }
        
        if let noti = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            print(noti)
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func listen(_ event: String, callBack: @escaping ListenerCallBack){
        if event.lowercased() == "ontoken" {
            onToken.append(callBack)
        }else if event.lowercased() == "onmessage" {
            onMessage.append(callBack)
        }else if event.lowercased() == "onConsent" {
            onConsent.append(callBack)
        }
    }
    
    private func appReady(){
        track(event: "app_launch")
        isAppReady = true
        pendingNotification.forEach {
            dispatch("onMessage", data: $0)
        }
    }
    
    private  func dispatch(_ event: String, data: [AnyHashable: Any]){
        
        var channel:[ListenerCallBack] = []
        
        if event.lowercased() == "ontoken" {
            channel = onToken
        }else if event.lowercased() == "onmessage" {
            channel = onMessage
        }else if event.lowercased() == "onConsent" {
            channel = onConsent
        }
        
        channel.forEach{
            $0(data)
        }
    }
    
    func askNotificationPermission(mediaAlias: String){
        if isEnableLog {
            print("🦄 PAM :  askNotificationPermission")
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:  [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                if self.isEnableLog {
                    print("🦄 PAM :  askNotificationPermission", error)
                }
            }else{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func track(event:String, payload: [String:Any]? = nil){
        let url = (config?.pamServer ?? "") + "/trackers/events"
        
        var body:[String:Any] = [
            "event":event,
            "platform": "iOS",
            "os_version": osVersion,
            "app_version": versionBuild,
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
        
        if custID == nil {
            formField["_database"] = config?.publicDBAlias ?? ""
        }else{
            formField["_database"] = config?.loginDBAlias ?? ""
        }
        
        body["form_fields"] = formField
        
        if isEnableLog {
            if let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) {
                print("🦄 PAM :  Post Tracking Event=\(event) payload=", String(data: bodyData, encoding: .utf8) ?? "nil")
            }
        }
        
        
        HttpClient.post(url: url, queryString: nil, headers: nil, json: body){
            if let contactID = $0?["contact_id"] as? String{
                
                if self.isEnableLog {
                    print("🦄 PAM :  Received Contact ID=", contactID)
                }
                
                let oldContactID = self.contactID ?? "-"
                if oldContactID != contactID {
                    self.contactID = contactID
                    self.saveValue(value: "contact_id", key: contactID)
                    if self.isEnableLog {
                        print("🦄 PAM :  Replace Old Contact ID='\(oldContactID)' with new contact ID='\(contactID)'")
                    }
                }
            }
        }
    }
    
    func userLogin(custID: String){
        
        if isEnableLog {
            print("🦄 PAM :  Login customer ID=\(custID)")
        }
        
        saveValue(value:custID, key: "cust_id")
        self.custID = custID
        let payLoad = [
            "customer": custID
        ]
        track(event: "login", payload: payLoad)
    }
    
    func userLogout(){
        if isEnableLog {
            print("🦄 PAM :  Logout")
        }
        custID  = nil
        removeValue(key: "cust_id")
        track(event: "logout")
    }
    
    func didReceiveRemoteNotification(userInfo:[AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool{
        
        if userInfo["_pam"] != nil{
            if isAppReady {
                dispatch("onMessage", data: userInfo)
            }else{
                pendingNotification.append(userInfo)
            }
            
            fetchCompletionHandler(.newData)
            return false
        }
        
        return true
    }
    
    private  func saveValue(value: String, key: String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    private  func readValue(key: String)-> String?{
        return UserDefaults.standard.string(forKey: key)
    }
    
    private  func removeValue(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func setDeviceToken(deviceToken:Data){
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        #if DEBUG
        let saveToken = "_" + token
        #else
        let saveToken = token
        #endif
        
        track(event: "save_push", payload: ["ios_notification":saveToken])
        
        if isEnableLog {
            print("🦄 PAM :  Save Push Notification Token=\(saveToken)")
        }
        
        dispatch("onToken", data: ["token": token])
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
    
    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    var versionBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    var osVersion: String {
        let version = ProcessInfo().operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
}


extension Pam {
    
    public static func track(event:String, payload: [String:Any]? = nil){
        Pam.shared.track(event: event, payload: payload)
    }
    
    public static func userLogin(custID: String){
        Pam.shared.userLogin(custID: custID)
    }
    
    public static func userLogout(){
        Pam.shared.userLogout()
    }
    
    public static func initialize(launchOptions:[UIApplication.LaunchOptionsKey: Any]?, enableLog: Bool = false ) throws {
        try Pam.shared.initialize(launchOptions: launchOptions, enableLog: enableLog)
    }
    
    public static func listen(_ event: String, callBack: @escaping ListenerCallBack){
        Pam.shared.listen(event, callBack: callBack)
    }
    
    public static func setDeviceToken(deviceToken:Data){
        Pam.shared.setDeviceToken(deviceToken: deviceToken)
    }
    
    static func didReceiveRemoteNotification(userInfo:[AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool{
        return Pam.shared.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: fetchCompletionHandler)
    }
    
    static func askNotificationPermission(mediaAlias: String){
        Pam.shared.askNotificationPermission(mediaAlias:mediaAlias)
    }
    
    static func appReady(){
        Pam.shared.appReady()
    }
}

extension Pam: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if isAppReady {
            dispatch("onMessage", data: response.notification.request.content.userInfo)
        }else{
            pendingNotification.append(response.notification.request.content.userInfo)
        }
    
        completionHandler()
    }
    
}
