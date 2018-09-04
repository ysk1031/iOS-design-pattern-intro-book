//
//  User.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let iconUrl: String
    let webUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case iconUrl = "avatar_url"
        case webUrl = "html_url"
    }
}
