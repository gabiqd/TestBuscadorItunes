//
//  TVShow.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 22/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation

class TVShow {
    var title: String?
    var episodeName: String?
    var imageURL: String?
    var description: String?
    var previewURL: String?
    
    init(title: String?, episodeName: String?, imageURL: String?, description: String?, previewURL: String?) {
        self.title = title
        self.episodeName = episodeName
        self.imageURL = imageURL
        self.description = description
        self.previewURL = previewURL
    }
}
