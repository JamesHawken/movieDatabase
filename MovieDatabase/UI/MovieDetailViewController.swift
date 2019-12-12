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

  
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var averageRate: UILabel!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var overview: UILabel!
  
    // MARK: - Lifecycle
    var actors = [Actor]() {
        didSet {
            actorCollectionView.reloadData()
        }
    }
    
    var moviePosters = [MoviePoster]() {
        didSet {
            actorCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actorCollectionView.dataSource = self
        
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
        
        
        MovieStore.getMoviePosters(movieId: String(movie.id)) { (moviePosters) in
           
            guard let backgroundImage = moviePosters[0].filePath
                else {
                    return
            }
            
          
            
            DispatchQueue.main.async {
                print(moviePosters[0].filePath)
                
                MovieStore.getImage(posterPath: backgroundImage) { _, image in
                    self.backgroundImage.image = image
                }
                for moviePoster in moviePosters {
                    self.moviePosters.append(moviePoster)
                }
            }
        }
        
            
    
     
        //actorTableView.heightAnchor = 120
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        movieDetailsController = segue.destination as? ViewController
        super.prepare(for: segue, sender: sender)
        
        guard let cell = sender as? UICollectionViewCell,
            let indexPath = actorCollectionView.indexPath(for: cell),
            let movieDetailViewController = segue.destination as? MovieDetailViewController
            else {
                return
        }
        
        let actor = actors[indexPath.row]
        movieDetailViewController.actor = actor
    }
    
    
}



extension MovieDetailViewController: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("we have entered")
        //print(actors)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ActorCollectionViewCell
        
        let actor = actors[indexPath.row]
        cell.name.text = actor.name
       
    
      
        MovieStore.getImage(posterPath: actor.profilePath ?? "") { path, image in
            if self.actors.count > indexPath.row {
                let newActor = self.actors[indexPath.row]
                if path == newActor.profilePath {
                    cell.actorImage.image = image
                } else {
                    cell.actorImage.image = nil
                }
            }
        }
        
        
        
        return cell
    }
    
    
   
    
    // MARK: - UITableViewDatasource
   
    
    
}
