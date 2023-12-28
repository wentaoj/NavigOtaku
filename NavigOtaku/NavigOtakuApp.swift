//
//  NavigOtakuApp.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI

enum URLError: Error {
    case BadURL, BadData
}

@main
struct NavigOtakuApp: App {
    let topAnimeHelper = TopAnimeHelper()
    let searchHelper = SearchHelper()
    let detailHelper = DetailHelper()
    let favoriteModel = FavoriteModel()
    let settings = SettingsModel()

    init() {
        if settings.notificationsEnabled {
            NotificationManager.shared.requestAuth()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(topAnimeHelper)
                .environmentObject(searchHelper)
                .environmentObject(detailHelper)
                .environmentObject(favoriteModel)
                .environmentObject(settings)
                .onAppear {
                    SoundManager().playSound()
                }
        }
    }
}
