//
//  SearchModel.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation

struct SearchAnime: Decodable {
    let title: String
    let description: String
    let pictureUrl: String
    let myanimelistUrl: String
    let myanimelistId: Int
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case pictureUrl = "picture_url"
        case myanimelistUrl = "myanimelist_url"
        case myanimelistId = "myanimelist_id"
    }
}

extension SearchAnime: Identifiable {
    var id: Int { myanimelistId }
}
