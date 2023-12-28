//
//  TopAnimeModel.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation

struct TopAnime: Decodable {
    let title: String
    let pictureUrl: String
    let myanimelistUrl: String
    let myanimelistId: Int
    let rank: Int
    let score: Double?
    let type: String
    let airedOn: String
    let members: Int

    enum CodingKeys: String, CodingKey {
        case title, rank, score, type, members
        case pictureUrl = "picture_url"
        case myanimelistUrl = "myanimelist_url"
        case myanimelistId = "myanimelist_id"
        case airedOn = "aired_on"
    }
}

extension TopAnime: Identifiable {
    var id: Int { myanimelistId }
}
