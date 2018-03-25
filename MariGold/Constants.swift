//
//  Constants.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 2/20/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Alamofire
import UserNotifications

struct api {
    static let rootURL = "https://marigoldapp.net"
}

protocol ServerError {
    var error_code: Int { get }
    var message: String { get }
    var name: String { get }
}

class User {
    static var isAuthenticated: Bool {
        let jwt = UserDefaults.standard.string(forKey: "jwt")
        if(jwt != nil) {
            return true
        } else {
            return false
        }
    }
    
    static var header: HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: "jwt")!,
            "Accept": "application/json"
        ]
        return headers;
    }
}

class Connectivity {
    static var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class Notify {
    static func createForMedication(medication: [String:Any]) {
        let center = UNUserNotificationCenter.current()
        let notifications = medication["notifications"] as! [[String:Any]]
    
        for notification in notifications {
            print(notification)
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Time to take your medication!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "It is time to take your ", arguments: nil)
            
            var weekday = (notification["weekday"] as! Int) + 2
            if(weekday > 7) {
                weekday = 0
            }
            
            var dateComponents = DateComponents()
            dateComponents.hour = (notification["hour"] as? Int)
            dateComponents.minute = (notification["minute"] as? Int)
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        }

//        var dateInfo = DateComponents()
//        dateInfo.hour = 7
//        dateInfo.minute = 0
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
//
//        let request = UNNotificationRequest(identifier: "Med reminder for this", content: content, trigger: trigger);
    }
}

