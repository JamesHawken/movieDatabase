//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Gil Nakache on 09/10/2019.
//  Copyright © 2019 Gil Nakache. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet var tableview: UITableView!
    
    var movies = [Movie]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableview.indexPath(for: cell),
            let movieDetailViewController = segue.destination as? MovieDetailViewController
        else {
            return
        }
        
        let movie = movies[indexPath.row]
        movieDetailViewController.movie = movie
    }
}

extension ViewController: UITableViewDataSource {
    // MARK: - UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellule", for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        cell.movieTitleLabel.text = movie.title
        cell.overViewLabel.text = movie.overview
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        cell.dateLabel.text = dateFormatter.string(from: movie.releaseDate ?? Date.distantPast)
        
        cell.ratingsLabel.text = String(repeating: "❤️", count: Int(movie.voteAverage))
        
        cell.posterImage.image = nil
        
        MovieStore.getImage(posterPath: movie.posterPath ?? "") { path, image in
            if self.movies.count > indexPath.row {
                let newMovie = self.movies[indexPath.row]
                if path == newMovie.posterPath {
                    cell.posterImage.image = image
                } else {
                    cell.posterImage.image = nil
                }
            }
        }
        
        return cell
    }
}
