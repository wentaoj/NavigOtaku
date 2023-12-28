//
//  AnimeDetailView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI

struct DetailView: View {
    let anime: TopAnime
    @State private var showWebView = false
    @State private var showingActionSheet = false
    @State private var showingPopup = false
    @State private var popupMessage = ""
    @EnvironmentObject var favoriteModel: FavoriteModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                if let fullImageUrl = DetailHelper.extractFullImageUrl(from: anime.pictureUrl),
                   let url = URL(string: fullImageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        LoadingAnimationView()
                    }
                    .aspectRatio(contentMode: .fit)
                }

                Text(anime.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // TODO: Replace to a star image.
                Button(action: {
                    if isFavorite() {
                        showingActionSheet = true
                    } else {
                        addToFavorites()
                    }
                }) {
                    Text(isFavorite() ? "Already in your Favorites! (remove?)" : "Add to Favorites")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Remove Favorite?"),
                                message: Text("Would you like to remove this anime from your favorites?"),
                                buttons: [
                                    .destructive(Text("Remove")) {
                                        removeFromFavorites()
                                    },
                                    .cancel()
                                ])
                }

                Text("Score: \(anime.score.map { String($0) } ?? "Upcoming \(anime.airedOn)!")")
                    .font(.title2)

                Text("Ranked: #\(anime.rank)")
                    .font(.title3)

                Text("Type: \(anime.type)")
                    .font(.headline)

                Text("Aired: \(anime.airedOn)")
                    .font(.headline)

                Text("Members: \(anime.members)")
                    .font(.headline)

                Button("View on MyAnimeList") {
                    self.showWebView = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingPopup) {
            Alert(
                title: Text(popupMessage),
                dismissButton: .default(Text("Got it!")) {
                    self.showingPopup = false
                }
            )
        }
        .sheet(isPresented: $showWebView) {
            if let url = URL(string: anime.myanimelistUrl) {
                WebView(url: url)
            }
        }
    }
    
    private func isFavorite() -> Bool {
        favoriteModel.favorites.contains(where: { $0.id == anime.myanimelistId })
    }

    private func addToFavorites() {
        let favorite = FavoriteAnime(
            myanimelistId: anime.myanimelistId,
            title: anime.title,
            pictureUrl: anime.pictureUrl,
            myanimelistUrl: anime.myanimelistUrl
        )
        favoriteModel.addFavorite(anime: favorite)
        popupMessage = "Added to Favorites"
        showingPopup = true
    }

    private func removeFromFavorites() {
        favoriteModel.removeFavorite(animeId: anime.myanimelistId)
        popupMessage = "Removed from Favorites"
        showingPopup = true
    }
}

struct DetailSearchView: View {
    let anime: SearchAnime
    @State private var showWebView = false
    @State private var showingActionSheet = false
    @State private var showingPopup = false
    @State private var popupMessage = ""
    @EnvironmentObject var favoriteModel: FavoriteModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let fullImageUrl = DetailHelper.extractFullImageUrl(from: anime.pictureUrl),
                   let url = URL(string: fullImageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        LoadingAnimationView()
                    }
                    .aspectRatio(contentMode: .fit)
                }

                Text(anime.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // TODO: Replace to a star image.
                Button(action: {
                    if isFavorite() {
                        showingActionSheet = true
                    } else {
                        addToFavorites()
                    }
                }) {
                    Text(isFavorite() ? "Already in your Favorites! (remove?)" : "Add to Favorites")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Remove Favorite?"),
                                message: Text("Would you like to remove this anime from your favorites?"),
                                buttons: [
                                    .destructive(Text("Remove")) {
                                        removeFromFavorites()
                                    },
                                    .cancel()
                                ])
                }

                if let url = URL(string: anime.myanimelistUrl) {
                    descriptionView(description: anime.description, readMoreUrl: url)
                }

                Text("Query ID: \(anime.myanimelistId)")
                    .font(.headline)

                Button("View on MyAnimeList") {
                    self.showWebView = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
            }
            .padding()
        }
        .navigationTitle("Anime Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingPopup) {
            Alert(
                title: Text(popupMessage),
                dismissButton: .default(Text("OK")) {
                    self.showingPopup = false
                }
            )
        }
        .sheet(isPresented: $showWebView) {
            WebView(url: URL(string: anime.myanimelistUrl)!)
        }
    }

    @ViewBuilder
    private func descriptionView(description: String, readMoreUrl: URL) -> some View {
        let readMoreText = "...read more."
        if let range = description.range(of: "...") {
            HStack(alignment: .top, spacing: 5) {
                VStack(alignment: .leading) {
                    Text("Synopsis:")
                        .font(.body)
                        .bold()
                    Text(String(description[..<range.lowerBound]))
                        .font(.body)
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    Text(readMoreText)
                        .font(.body)
                        .bold()
                        .italic()
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.showWebView = true
                        }
                }
            }
        } else {
            Text("Synopsis: \(description)")
                .font(.body)
        }
    }
    
    private func isFavorite() -> Bool {
        favoriteModel.favorites.contains { $0.id == anime.myanimelistId }
    }

    private func addToFavorites() {
        let favorite = FavoriteAnime(
            myanimelistId: anime.myanimelistId,
            title: anime.title,
            pictureUrl: anime.pictureUrl,
            myanimelistUrl: anime.myanimelistUrl
        )
        favoriteModel.addFavorite(anime: favorite)
        popupMessage = "Added to Favorites"
        showingPopup = true
    }

    private func removeFromFavorites() {
        favoriteModel.removeFavorite(animeId: anime.myanimelistId)
        popupMessage = "Removed from Favorites"
        showingPopup = true
    }
}

// NOTE: ACCESS FROM FAVORITE VIEW
struct DetailFavoriteView: View {
    @EnvironmentObject var settings: SettingsModel
    let favorite: FavoriteAnime
    @State private var showWebView = false
    @State private var selectedDate = Date()
    @State private var showNotificationSetup = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let url = URL(string: DetailHelper.extractFullImageUrl(from: favorite.pictureUrl) ?? favorite.pictureUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        LoadingAnimationView()
                    }
                    .aspectRatio(contentMode: .fit)
                }

                Text(favorite.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("MyAnimeList ID: \(favorite.myanimelistId)")
                    .font(.headline)

                Button("Watch now on MyAnimeList!") {
                    self.showWebView = true
                }
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // User Notification
                if showNotificationSetup {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())

                    HStack(alignment: .center) {
                        Section("Select Time"){
                            DatePicker("Select Time", selection: $selectedDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                    }
                    
                    Button("Schedule Notification") {
                        scheduleNotification()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                } else {
                    Button("Set Reminder") {
                        showNotificationSetup.toggle()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showWebView) {
            WebView(url: URL(string: favorite.myanimelistUrl)!)
        }
        .navigationTitle("Anime Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func scheduleNotification() {
        let title = "Reminder for \(favorite.title)"
        let notes = "Check out \(favorite.title) on MyAnimeList!"
        NotificationManager.shared.scheduleNotification(title: title, notes: notes, date: selectedDate)
        showNotificationSetup = false
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAnime = TopAnime(
            title: "この素晴らしい世界に祝福を！",
            pictureUrl: "https://cdn.myanimelist.net/images/anime/r/50x70/8/77831.jpg?s=29949c6e892df123f0b0563e836d3d98",
            myanimelistUrl: "https://myanimelist.net/anime/30831/Kono_Subarashii_Sekai_ni_Shukufuku_wo",
            myanimelistId: 30831,
            rank: 465,
            score: 8.11,
            type: "TV (10 eps)",
            airedOn: "Jan 2016 - Mar 2016",
            members: 1913010
        )
        
        DetailView(anime: sampleAnime)
            .previewLayout(.sizeThatFits)
            .environmentObject(FavoriteModel())
    }
}
