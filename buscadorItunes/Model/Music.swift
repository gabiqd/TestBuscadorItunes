//
//  Music.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 22/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation

class Music {
    var title: String?
    var artistName: String?
    var discImageURL: String?
    var previewURL: String?
    
    init(title: String?, artistName: String?, discImageURL: String?, previewURL: String?) {
        self.title = title
        self.artistName = artistName
        self.discImageURL = discImageURL
        self.previewURL = previewURL
    }
}
