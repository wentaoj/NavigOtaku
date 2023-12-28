//
//  ContentView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: SettingsModel
    @StateObject private var soundManager = SoundManager()
    var body: some View {
        TabView {
            TopAnimeView()
                .tabItem {
                    Label {
                        Text(TabType.topAnime.title())
                    } icon: {
                        Image(TabType.topAnime.image())
                            .renderingMode(.original)
                    }
                }
                .tag(0)
                .foregroundColor(settings.actualTextColor)
            SearchView()
                .tabItem {
                    Label {
                        Text(TabType.search.title())
                    } icon: {
                        Image(TabType.search.image())
                            .renderingMode(.original)
                    }
                }
                .tag(1)
                .foregroundColor(settings.actualTextColor)
            FavoriteView()
                .tabItem {
                    Label {
                        Text(TabType.favorite.title())
                    } icon: {
                        Image(TabType.favorite.image())
                            .renderingMode(.original)
                    }
                }
                .tag(2)
                .foregroundColor(settings.actualTextColor)
            SettingsView()
                .tabItem {
                    Label {
                        Text(TabType.setting.title())
                    } icon: {
                        Image(TabType.setting.image())
                            .renderingMode(.original)
                    }
                }
                .tag(3)
                .foregroundColor(settings.actualTextColor)
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        .onChange(of: settings.isDarkMode) {
            withAnimation(.easeInOut(duration: 0.5)) {
            }
        }
        .onAppear {
            soundManager.playSound()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TopAnimeHelper())
            .environmentObject(SearchHelper())
            .environmentObject(DetailHelper())
            .environmentObject(FavoriteModel())
            .environmentObject(SettingsModel())
    }
}
