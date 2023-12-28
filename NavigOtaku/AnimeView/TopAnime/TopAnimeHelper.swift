//
//  ImageHelper.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import Foundation

class TopAnimeHelper: ObservableObject {
    @Published var topAnime: [TopAnime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchTopAnime(completion: @escaping (Error?) -> Void) {
        self.isLoading = true
        let headers = [
            "X-RapidAPI-Key": APIKeys.getNextKey(),
            "X-RapidAPI-Host": APIHosts.host
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://myanimelist.p.rapidapi.com/anime/top/upcoming")! as URL,
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
                    completion(error)
                    return
                }
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    completion(nil)
                    return
                }
                do {
                    self?.topAnime = try JSONDecoder().decode([TopAnime].self, from: data)
                    completion(nil)
                } catch {
                    self?.errorMessage = error.localizedDescription
                    completion(error)
                }
            }
        }.resume()
    }
}
