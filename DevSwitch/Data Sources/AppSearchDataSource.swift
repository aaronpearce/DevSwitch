//
//  AppSearchDataSource.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 5/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation

class AppSearchDataSource {
    
    var response: AppSearchResponse?
    
    func search(for term: String?, completion: @escaping (() -> ())) {
        guard let term = term?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
    
        let urlString = "http://itunes.apple.com/search?term=\(term)&entity=software"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(AppSearchResponse.self, from: data)
                self?.response = responseModel
                
                
            } catch let err {
                self?.response = nil
                print("Err", err)
            }
            
            DispatchQueue.main.async {
                completion()
            }
            
        }.resume()
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(for section: Int) -> Int {
        return response?.resultCount ?? 0
    }
    
    func result(for indexPath: IndexPath) -> AppSearchResult? {
        return response?.results[indexPath.item]
    }
}

struct AppSearchResponse: Codable {
    let resultCount: Int
    let results: [AppSearchResult]
}

struct AppSearchResult: Codable {
    let artworkUrl100: URL
    let trackName: String
    let trackId: Int
    let sellerName: String
}
