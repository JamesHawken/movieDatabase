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
    
    @IBOutlet var scrollview: UIScrollView!
    var movie: Movie?
    var actor : Actor?
    var moviePoster: MoviePoster?
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet var moviePosterCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var averageRate: UILabel!
    //@IBOutlet var topImageView: UIImageView!
    @IBOutlet var overview: UILabel!
  
    // MARK: - Lifecycle
    var actors = [Actor]() {
        didSet {
    
            actorCollectionView.reloadData()
        }
    }
    
    var moviePosters = [MoviePoster]() {
        didSet {
            
            moviePosterCollectionView.reloadData()
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
        
        //MovieStore.getImage(posterPath: urlPath) { _, image in
            //self.topImageView.image = image
        //}
        MovieStore.getActors(movieId: String(movie.id)) { (cast) in
         print(cast[0].name)
            DispatchQueue.main.async {
            
            for actor in cast {
              self.actors.append(actor)
            }
        }
            
        }
        
        
        MovieStore.getMoviePosters(movieId: String(movie.id)) { (moviePosters) in
           
            guard let backgroundImage = moviePosters[1].filePath
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
        
            
    
     
        moviePosterCollectionView.delegate = self as? UICollectionViewDelegate
        actorCollectionView.delegate = self as? UICollectionViewDelegate
        
        moviePosterCollectionView.dataSource = self
        actorCollectionView.dataSource = self
       
        self.scrollview.addSubview(moviePosterCollectionView)
        
        self.scrollview.addSubview(actorCollectionView)
        

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
      
       
      //  movieDetailViewController.moviePoster=moviePoster
    }
   
    
}






extension MovieDetailViewController: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   

    {
        if collectionView == actorCollectionView {
        return actors.count
        }
        else {
            return moviePosters.count
        }
      
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("we have entered")
        //print(actors)
        
        
        if (collectionView == actorCollectionView) {
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
        else {
            
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviePosterCell", for: indexPath) as! MoviePosterCollectionViewCell
        
            print("we are in moviePosterCollectionView")
           
            let moviePoster = moviePosters[indexPath.row]
            print(moviePoster)
            MovieStore.getImage(posterPath: moviePoster.filePath ?? "") { path, image in
                if self.moviePosters.count > indexPath.row {
                    print("we are in getImage")
                    let newMoviePoster = self.moviePosters[indexPath.row]
                    if path == newMoviePoster.filePath {
                        cell.MoviePoster.image = image
                        print ("we are in cell fill")
                    } else {
                       cell.MoviePoster.image = nil
                    }
                }
            }
            
            return cell
            
        }
        
        

        
     
    }
    
    
   
    
    // MARK: - UITableViewDatasource
   
    
    
}
