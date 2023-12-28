//
//  SearchHelper.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation

class SearchHelper: ObservableObject {
    @Published var searchResults: [SearchAnime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func searchAnime(query: String, completion: ((Error?) -> Void)? = nil) {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
        self.isLoading = true
        let headers = [
            "X-RapidAPI-Key": APIKeys.getNextKey(),
            "X-RapidAPI-Host": APIHosts.host
        ]

        let urlString = "https://myanimelist.p.rapidapi.com/v2/anime/search?q=\(query)&n=30&score=8"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            self.errorMessage = "Invalid URL"
            completion?(nil)
            return
        }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion?(error)
                    return
                }
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    completion?(nil)
                    return
                }
                do {
                    self?.searchResults = try JSONDecoder().decode([SearchAnime].self, from: data)
                    completion?(nil)
                } catch {
                    self?.errorMessage = error.localizedDescription
                    completion?(error)
                }
            }
        }.resume()
    }
}
