//
//  ImageView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI

struct TopAnimeView: View {
    @EnvironmentObject var topAnimeHelper: TopAnimeHelper
    
    var body: some View {
        NavigationView {
            Group {
                if topAnimeHelper.isLoading {
                    VStack {
                        LoadingAnimationView()
                        Text("Now Loading...")
                    }
                } else if topAnimeHelper.errorMessage != nil {
                    Text("⚠️ Whoops! \n\nLooks like we've hit the API query limit. \n\nCould you please refresh, \nso we can try a different key?")
                } else if topAnimeHelper.topAnime.isEmpty {
                    Text("Sorry! No upcoming anime found.")
                } else {
                    animeList
                }
            }
            .navigationTitle("Upcoming Anime")
        }
        .onAppear {
            topAnimeHelper.fetchTopAnime { error in
                if let error = error {
                    print("Fetch topAnime error: \(error.localizedDescription)")
                }
            }
        }

    }

    private var animeList: some View {
        List(topAnimeHelper.topAnime) { anime in
            NavigationLink(destination: DetailView(anime: anime)) {
                HStack {
                    AsyncImage(url: URL(string: anime.pictureUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        LoadingAnimationView()
                    }
                    .frame(width: 50, height: 70)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(anime.title)
                            .font(.headline)
                        Text("Aired on: \(anime.airedOn)")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct TopAnimeView_Previews: PreviewProvider {
    static var previews: some View {
        TopAnimeView()
            .environmentObject(TopAnimeHelper())
    }
}
