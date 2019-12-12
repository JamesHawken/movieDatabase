//
//  MoviePoster.swift
//  MovieDatabase
//
//  Created by James Hawken on 12/12/2019.
//  Copyright © 2019 Gil Nakache. All rights reserved.
//

import UIKit


    struct MoviePoster {
        var filePath:String?
    }
    
    
    struct MoviePosterResponse {
        var posters: [MoviePoster]
    }
    extension MoviePoster: Codable {}
    extension MoviePosterResponse: Codable {}


