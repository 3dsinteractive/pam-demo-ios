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
    
    static var config: PamConfig?
    
    static func initialize() throws {
        if let filepath = Bundle.main.path(forResource: "pam-config", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                Pam.config = try JSONDecoder().decode(PamConfig.self, from: contents.data(using: .utf8)!)
                if Pam.config?.pamServer.hasSuffix("/") ?? false {
                    Pam.config?.pamServer.removeLast()
                }
            } catch {
                throw RuntimeError("PAM Error!! Invalid JSON Format 'pam-config.json' \(error)")
            }
        } else {
            throw RuntimeError("PAM Error!! File not found 'pam-config.json'")
        }
    }
    
    static func askNotificationPermission(mediaAlias: String, options: UNAuthorizationOptions){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print(error)
            }else{
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    static func track(event:String, payload: [String:Any]? = nil){
        let url = (Pam.config?.pamServer ?? "") + "/trackers/events"
        
        HttpClient.post(url: url, queryString: nil, headers: nil, json: payload)
    }
    
    static func setPushNotification(userInfo:[AnyHashable : Any], completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool{
        if let info = userInfo["pam"] {
            completionHandler(.newData)
            return true
        }
        return false
    }
    
    static func setDeviceToken(deviceToken:Data) -> String{
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        #if DEBUG
        let saveToken = "_" + token
        #else
        let saveToken = token
        #endif
        
        Pam.track(event: "save_roken", payload: ["ios_notification":saveToken])
        
        return token
    }
}


class HttpClient {
    
    static func post(url:String, queryString: [String:String]?, headers:[String:String]?, json: [String: Any]?){
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
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error == nil, let data = data{
                if let json = String(data: data, encoding: .utf8){
                    print(json)
                }
            }
        }.resume()
        
    }
    
}
