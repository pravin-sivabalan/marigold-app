//
//  Constants.swift
//  MariGold
//
//  Created by Pravin Sivabalan on 2/20/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

struct api {
    static let rootURL = "https://marigoldapp.net"
}

protocol ServerError {
    var error_code: Int { get }
    var message: String { get }
    var name: String { get }
}
