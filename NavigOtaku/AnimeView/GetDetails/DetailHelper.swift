//
//  DetailHelper.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation

class DetailHelper: ObservableObject {
    @Published var animeDetail: DetailModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchAnimeDetail(id: Int) {
        self.isLoading = true
        let headers = [
            "X-RapidAPI-Key": APIKeys.getNextKey(),
            "X-RapidAPI-Host": APIHosts.host
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://myanimelist.p.rapidapi.com/anime/\(id)")! as URL,
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
                    return
                }
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                do {
                    self?.animeDetail = try JSONDecoder().decode(DetailModel.self, from: data)
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
    
    static func extractFullImageUrl(from thumbnailUrl: String) -> String? {
        let pattern = "https://cdn.myanimelist.net/r/\\d+x\\d+/images/anime/"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        if let match = regex?.firstMatch(in: thumbnailUrl, options: [], range: NSRange(location: 0, length: thumbnailUrl.utf16.count)),
           let range = Range(match.range, in: thumbnailUrl) {
            let newUrl = thumbnailUrl.replacingCharacters(in: range, with: "https://cdn.myanimelist.net/images/anime/")
            return newUrl.components(separatedBy: "?").first
        }
        return nil
    }
}

