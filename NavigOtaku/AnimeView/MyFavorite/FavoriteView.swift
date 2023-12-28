//
//  FavoriteView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var favoriteModel: FavoriteModel
    @EnvironmentObject var settings: SettingsModel
    @State private var isEditMode = false
    @State private var showingActionSheet = false
    @State private var selectedAnime: FavoriteAnime?

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(favoriteModel.favorites) { favorite in
                        ZStack(alignment: .topLeading) {
                            NavigationLink(destination: DetailFavoriteView(favorite: favorite)) {
                                VStack {
                                    if let fullImageUrl = DetailHelper.extractFullImageUrl(from: favorite.pictureUrl),
                                       let url = URL(string: fullImageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            LoadingAnimationView()
                                        }
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                    }
                                    Text(favorite.title)
                                        .font(.caption)
                                        .lineLimit(3)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            if isEditMode {
                                Button(action: {
                                    selectedAnime = favorite
                                    showingActionSheet = true
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(4)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(isEditMode ? "Done" : "Edit") {
                isEditMode.toggle()
            })
            .navigationTitle("Favorite Anime")
        }
        .onAppear {
            favoriteModel.loadFavorites()
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Confirm Delete?"),
                message: Text("Are you sure you want to remove this anime from favorites?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        if let selectedAnime = selectedAnime {
                            favoriteModel.removeFavorite(animeId: selectedAnime.id)
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(FavoriteModel())
            .environmentObject(SettingsModel())
    }
}
