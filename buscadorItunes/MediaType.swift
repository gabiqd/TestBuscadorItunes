//
//  MediaType.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 21/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

enum MediaType {
    case music
    case tvShow
    case movie
    
    var param: String {
        get {
            switch self {
            case .music:
                return "music"
            case .tvShow:
                return "tvShow"
            case .movie:
                return "movie"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .music:
                return "Music"
            case .tvShow:
                return "TV Show"
            case .movie:
                return "Movie"
            }
        }
    }
    
}
