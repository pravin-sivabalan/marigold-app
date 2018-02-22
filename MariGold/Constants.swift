//
//  Constants.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 2/20/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Alamofire

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
