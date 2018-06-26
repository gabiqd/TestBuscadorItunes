//
//  Movie.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 22/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation

class Movie {
    var title: String?
    var description: String?
    var imageURL: String?
    var previewURL: String?
    
    init(title: String?, description: String?, imageURL: String?, previewURL: String?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.previewURL = previewURL
    }
}
