//
//  FavoriteModel.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation

struct FavoriteAnime: Codable {
    let myanimelistId: Int
    let title: String
    let pictureUrl: String
    let myanimelistUrl: String
}

extension FavoriteAnime: Identifiable {
    var id: Int { myanimelistId }
}

class FavoriteModel: ObservableObject {
    @Published var favorites: [FavoriteAnime] = []

    private var favoritesFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("favorites.json")
    }

    func loadFavorites() {
        do {
            let data = try Data(contentsOf: favoritesFileURL)
            favorites = try JSONDecoder().decode([FavoriteAnime].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
        }
    }

    func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: favoritesFileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error saving favorites: \(error)")
        }
    }

    func addFavorite(anime: FavoriteAnime) {
            if !favorites.contains(where: { $0.id == anime.id }) {
                favorites.append(anime)
                saveFavorites()
            }
        }
    
    func removeFavorite(animeId: Int) {
        if let index = favorites.firstIndex(where: { $0.id == animeId }) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }
}
