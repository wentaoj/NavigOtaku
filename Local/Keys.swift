//
//  Keys.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation

struct APIKeys {
    private static let keys = [
        "c0fadf5c79msh7d1cfa9556238cep1327b9jsna31d659c8798",
        "473e4e2088msha454024e5a22ff0p1922c7jsn847a7263baae",
        "2d332c6a78mshffe66ac276d1349p157791jsne100af330c66"
    ]
    private static var index = 0

    static func getNextKey() -> String {
        let key = keys[index]
        index = (index + 1) % keys.count
        return key
    }
}

struct APIHosts {
    static let host = "myanimelist.p.rapidapi.com"
}
