//
//  QuoteFetcher.swift
//  Ye
//
//  Created by Jason on 10/4/24.
//

import Foundation

struct QuoteFetcher {
    // 랜덤 명언 가져오기 (ZenQuotes API 사용)
    static func fetchRandomQuote(completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: "https://zenquotes.io/api/random") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error fetching quote: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstQuote = jsonArray.first,
                   let quoteText = firstQuote["q"] as? String,
                   let author = firstQuote["a"] as? String {
                    completion(.success((quoteText, author)))
                }
            } catch {
                completion(.failure(error))
                print("Error parsing JSON: \(error)")
            }
        }

        task.resume()
    }

    // Kanye West 명언 가져오기
    static func fetchKanyeQuote(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.kanye.rest/") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error fetching quote: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let quoteText = json["quote"] {
                    completion(.success(quoteText))
                }
            } catch {
                completion(.failure(error))
                print("Error parsing JSON: \(error)")
            }
        }

        task.resume()
    }
}
