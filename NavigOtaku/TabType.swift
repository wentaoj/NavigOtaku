//
//  TabType.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation
import SwiftUI

enum TabType: Int, CaseIterable {
    case topAnime, search, favorite, setting
    
    func title() -> String {
        switch self {
        case .topAnime:
            return "Upcoming".capitalized
        case .search:
            return "Search".capitalized
        case .favorite:
            return "My Favorite".capitalized
        case .setting:
            return "Settings".capitalized
        }
    }
    
    func image() -> String {
        switch self {
        case .topAnime:
            return "topAnime"
        case .search:
            return "search"
        case .favorite:
            return "favorite"
        case .setting:
            return "setting"
        }
    }
    
}
