//
//  MovieStore.swift
//  MovieDatabase
//
//  Created by Gil Nakache on 16/10/2019.
//  Copyright © 2019 Gil Nakache. All rights reserved.
//

import Foundation
import UIKit

class MovieStore {
    //Properties
    static let apiKey = URLQueryItem(name: "api_key", value: "53ba643986598c56bd34d0b506ae3f5c")
    static let language = URLQueryItem(name: "language", value: "fr")
    static let baseUrlComponents = URLComponents(string: "https://api.themoviedb.org/3/")
    static var currentTask: URLSessionDataTask?
    
    static func getImage(posterPath: String, completionHandler: @escaping (String, UIImage?) -> Void) {
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let url = URL(string: baseURLString + posterPath)!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            var image: UIImage?
            
            if let data = data {
                image = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completionHandler(posterPath, image)
            }
            
        }.resume()
    }
    
    static func getMovies(completionHandler: @escaping ([Movie]) -> Void) {
        var urlComponents = baseUrlComponents
        
        urlComponents?.path.append("movie/now_playing")
        urlComponents?.queryItems = [apiKey, language]
        
        getMovies(url: urlComponents!.url!, completionHandler: completionHandler)
    }
    
    
    static func getActors(movieId:String, completionHandler: @escaping (Array<Actor>) -> Void) {
        var urlComponents = baseUrlComponents
        urlComponents?.path.append("movie/")
        urlComponents?.path.append(movieId)
        urlComponents?.path.append("/credits")
        urlComponents?.queryItems = [apiKey]
        print("heeeey")
        print(urlComponents!.url!)
        
         URLSession.shared.dataTask(with: urlComponents!.url!) { data, _, error in
            if let data = data {
                
                do {
              //      print(data)
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let actorResponse = try jsonDecoder.decode(ActorResponse.self, from: data)
                //    print(actorResponse.cast)
                   completionHandler(actorResponse.cast)
                    
                   // let id:Int = movieResponse.results[2].id
                    
                  //  getActors(movieId: String(id), url: url, //completionHandler:completionHandler)
                } catch {
                    print("erreur lors du getActor")
                    //completionHandler(Movie)
                }
            }
    
        
        }.resume()
    }
    
    static func getMovies(url: URL, completionHandler: @escaping ([Movie]) -> Void) {
        currentTask?.cancel()
        currentTask = nil
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    jsonDecoder.dateDecodingStrategy = .custom { (decoder) -> Date in
                        
                        do {
                            let container = try decoder.singleValueContainer()
                            let dateString = try container.decode(String.self)
                            let date = dateFormatter.date(from: dateString)
                            return date ?? Date.distantPast
                        } catch {
                            return Date.distantPast
                        }
                    }
                    
                    let movieResponse = try jsonDecoder.decode(MovieResponse.self, from: data)
                    completionHandler(movieResponse.results)
                  
                    
           
                } catch {
                    completionHandler([Movie]())
                }
            }
        }
        
        task.resume()
        
        currentTask = task
    }
    
    static func searchMovies(queryString: String, completionHandler: @escaping ([Movie]) -> Void) {
        let query = URLQueryItem(name: "query", value: queryString)
        
        var urlComponents = baseUrlComponents
        urlComponents?.path.append("search/movie")
        urlComponents?.queryItems = [apiKey, language, query]
        
        getMovies(url: urlComponents!.url!, completionHandler: completionHandler)
    }
}

