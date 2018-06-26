//
//  NetworkingServices.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 22/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation

struct RootMovie: Decodable {
    var resultCount: Int
    var results: [MovieDecodable]
}

struct RootMusic: Decodable {
    var resultCount: Int
    var results: [MusicDecodable]
}

struct RootTvShow: Decodable {
    var resultCount: Int
    var results: [TVShowDecodable]
}

struct MovieDecodable: Decodable {
    var trackName: String
    var artworkUrl100: String
    var longDescription: String
    var previewUrl: String
}

struct TVShowDecodable: Decodable {
    var artistName: String
    var trackName: String
    var artworkUrl100: String
    var longDescription: String
    var previewUrl: String
}

struct MusicDecodable: Decodable {
    var trackName: String
    var artistName: String
    var artworkUrl100: String
    var previewUrl: String
}

class NetworkingServices {
    typealias JsonResultCompletition = ([(AnyObject, MediaType)], String) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var resultList: [(AnyObject, MediaType)] = []
    var errorMessage = ""
    
    func getSearchResult(searchQuery: String, mediaTypes: [MediaType], completion: @escaping JsonResultCompletition) {
        dataTask?.cancel()
        resultList.removeAll()
        let i = 0
        getSearchInfo(searchQuery: searchQuery, mediaTypes: mediaTypes, index: i, completion: completion)
    }
    
    func getSearchInfo(searchQuery: String, mediaTypes: [MediaType], index: Int, completion: @escaping JsonResultCompletition) {
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=\(mediaTypes[index])&term=\(searchQuery)"
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                        self.parseJsonData(data: data, mediaType: mediaTypes[index])
                        if index == mediaTypes.count - 1{
                        DispatchQueue.main.async {
                            completion(self.resultList, self.errorMessage)
                        }
                    }else{
                        let i = index + 1
                        self.getSearchInfo(searchQuery: searchQuery, mediaTypes: mediaTypes, index: i, completion: completion)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func parseJsonData(data: Data, mediaType: MediaType) {
        do {
            switch mediaType {
            case .music:
                let jsonResult = try JSONDecoder().decode(RootMusic.self, from: data)
                for result in jsonResult.results {
                    let musicObject = Music(title: result.trackName, artistName: result.artistName, discImageURL: result.artworkUrl100, previewURL: result.previewUrl)
                    resultList.append((musicObject, .music))
                }
            case .tvShow:
                let jsonResult = try JSONDecoder().decode(RootTvShow.self, from: data)
                for result in jsonResult.results {
                    let tvShowObject = TVShow(title: result.artistName, episodeName: result.trackName, imageURL: result.artworkUrl100, description: result.longDescription, previewURL: result.previewUrl)
                    
                    resultList.append((tvShowObject, .tvShow))
                }
            case .movie:
                let jsonResult = try JSONDecoder().decode(RootMovie.self, from: data)
                for result in jsonResult.results {
                    let movieObject = Movie(title: result.trackName, description: result.longDescription, imageURL: result.artworkUrl100, previewURL: result.previewUrl)
                    
                    resultList.append((movieObject, .movie))
                }
            }
        } catch {
            print(error)
        }
    }
}
