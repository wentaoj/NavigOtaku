//
//  DetailModel.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation

struct DetailModel: Decodable {
    let titleOv: String
    let titleEn: String
    let synopsis: String
    let alternativeTitles: AlternativeTitles
    let information: Information
    let statistics: Statistics
    let characters: [Character]
    let pictureUrl: String

    enum CodingKeys: String, CodingKey {
        case titleOv = "title_ov"
        case titleEn = "title_en"
        case synopsis
        case alternativeTitles = "alternative_titles"
        case information
        case statistics
        case characters
        case pictureUrl = "picture_url"
    }

    struct AlternativeTitles: Decodable {
        let synonyms: String
        let japanese: String
        let english: String
        let german: String?
        let spanish: String?
        let french: String?
    }

    struct Information: Decodable {
        let type: [NameURL]
        let episodes: String
        let status: String
        let aired: String
        let premiered: [NameURL]
        let broadcast: String
        let producers: [NameURL]
        let licensors: [NameURL]
        let studios: [NameURL]
        let source: String
        let genre: String?
        let theme: String?
        let duration: String
        let rating: String
        let genres: [NameURL]
        let themes: [NameURL]
        let demographic: [NameURL]?
    }

    struct Statistics: Decodable {
        let score: Double
        let ranked: Int
        let popularity: Int
        let members: Int
        let favorites: Int
    }

    struct Character: Decodable {
        let name: String
        let pictureUrl: String
        let myanimelistUrl: String
        let voiceActorName: String
        let voiceActorPictureUrl: String
        let voiceActorMyanimelistUrl: String

        enum CodingKeys: String, CodingKey {
            case name
            case pictureUrl = "picture_url"
            case myanimelistUrl = "myanimelist_url"
            case voiceActorName = "voice_actor_name"
            case voiceActorPictureUrl = "voice_actor_picture_url"
            case voiceActorMyanimelistUrl = "voice_actor_myanimelist_url"
        }
    }

    struct NameURL: Decodable {
        let name: String
        let url: String
    }
}
