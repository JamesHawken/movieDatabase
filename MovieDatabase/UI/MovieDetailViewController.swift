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
    var movieDetailsController: ViewController?
    var movie: Movie?
    var actor : Actor?

    @IBOutlet var actorTableView: UITableView!
    
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var averageRate: UILabel!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var overview: UILabel!
  
    // MARK: - Lifecycle
    var actors = [Actor]() {
        didSet {
            actorTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actorTableView.dataSource = self

        
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
            DispatchQueue.main.async {
            
            for actor in cast {
              self.actors.append(actor)
            }
        }
            
        
            
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        movieDetailsController = segue.destination as? ViewController
        super.prepare(for: segue, sender: sender)
        
        guard let cell = sender as? UITableViewCell,
            let indexPath = actorTableView.indexPath(for: cell),
            let movieDetailViewController = segue.destination as? MovieDetailViewController
            else {
                return
        }
        
        let actor = actors[indexPath.row]
        movieDetailViewController.actor = actor
    }
    
    
}



extension MovieDetailViewController: UITableViewDataSource {
    // MARK: - UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("we have entered")
        //print(actors)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActorTableViewCell", for: indexPath) as! ActorTableViewCell
        
        let actor = actors[indexPath.row]
        cell.name.text = actor.name
        cell.character.text = actor.character
        cell.id.text = String(actor.castId)
       
    
        
    
        
        return cell
}
}
