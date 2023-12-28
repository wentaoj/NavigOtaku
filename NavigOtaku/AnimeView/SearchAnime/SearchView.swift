//
//  SearchView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchHelper: SearchHelper
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            Group {
                if searchHelper.isLoading {
                    VStack {
                        LoadingAnimationView()
                        Text("Actively Searching...")
                    }
                } else if searchHelper.errorMessage != nil {
                    Text("⚠️ Whoops! \n\nLooks like we've hit the API query limit. \n\nCould you please refresh, \nso we can try a different key?")
                } else if searchHelper.searchResults.isEmpty && !searchText.isEmpty {
                    Text("Sorry! Cannot find this result.")
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Search Anime")
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                searchHelper.searchAnime(query: searchText)
            }
        }
    }

    private var searchResultsList: some View {
        List(searchHelper.searchResults) { anime in
            NavigationLink(destination: DetailSearchView(anime: anime)) {
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
                        Text(anime.description)
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchHelper())
    }
}
