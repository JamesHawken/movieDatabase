//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by Gil Nakache on 13/11/2019.
//  Copyright © 2019 Gil Nakache. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Variables
    
    var movie: Movie?
    
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var averageRate: UILabel!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var overview: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else { return }
        
        navigationItem.title = movie.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        releaseDate.text = dateFormatter.string(from: movie.releaseDate ?? Date.distantPast)
        averageRate.text = String(repeating: "❤️", count: Int(movie.voteAverage))
        overview.text = movie.overview
        
        guard let urlPath = movie.backdropPath
        else {
            return
        }
        
        MovieStore.getImage(posterPath: urlPath) { _, image in
            self.topImageView.image = image
        }
        MovieStore.getActors(movieId: String(movie.id)) { (cast) in
         print(cast[0].name)
        }
            
        
            
            
        }
        
    }

