//
//  ApiCaller.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 26/02/2023.
//

import Foundation

struct Constants
{
    static let api_key = "7c39a2d5cd08b3f9ce5876cf7cf1e2f9"
    static let base_Url = "https://api.themoviedb.org/"
    static let Youtube_apiKey = "AIzaSyCwkQLwi6X5mqR_Ez_PgunkCojPo9ODF5A"
    static let Youtubebae_url = "https://youtube.googleapis.com/youtube/v3/search?"
    
}
enum ApiError: Error
{
    case failedTogetData
}


 
class apiCaller
{
    static let shared = apiCaller()
     
    func getTrendingMovies(completion: @escaping (Result<[Tittle], (Error)>) -> Void)
    {
        guard let url = URL(string: "\(Constants.base_Url)/3/trending/movie/day?api_key=\(Constants.api_key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
                                              {data, _, error in
            guard let data = data, error == nil else{
                return
            }
        do
        { 
            let results = try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
            completion(.success(results.results))  
        }
        catch
        {
            completion(.failure(ApiError.failedTogetData))
        }
        }
        task.resume()
    }
    
    
    func  getTrendingTV(completion: @escaping (Result<[Tittle],(Error)>) -> Void)
    {
        guard let url =  URL(string:  "\(Constants.base_Url)/3/trending/tv/day?api_key=\(Constants.api_key)")
        else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
        { data, _, error in
            guard let data =  data, error == nil else {
                return
            } 
            do
            {
                let results =  try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch
            {
                completion(.failure(ApiError.failedTogetData))
        }
        }
        task.resume()
                
    }

//https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
    func  getUpcomingMovies(completion: @escaping (Result<[Tittle], (Error)>) -> Void)
    {
        guard let url = URL(string: "\(Constants.base_Url)/3/movie/upcoming?api_key=\(Constants.api_key)")
        else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(ApiError.failedTogetData))
            }
        }
        task.resume()
    }
    
    //https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
    
    func getPopularMovies(completion: @escaping(Result<[Tittle], (Error)>) -> Void)
    {
        guard let url = URL(string: "\(Constants.base_Url)/3/movie/popular?api_key=\(Constants.api_key)")
        else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url:url))
        {data, _, error in guard let data = data, error == nil else
            {
            return
        }
            do{
                let results = try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch
            {
                completion(.failure(ApiError.failedTogetData))
            }
            }
        task.resume()
    }
    
    ///https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
    func  getTopRated(completion: @escaping(Result<[Tittle], (Error)>) -> Void)
    {
        guard let url = URL(string: "\(Constants.base_Url)/3/movie/top_rated?api_key=\(Constants.api_key)")
        else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url:url))
        {data, _, error in guard let data = data, error == nil else
            {
            return
        }
            do{
                let results =  try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(ApiError.failedTogetData))
            }
            }
        task.resume()
    }
        
        func getDiscoverMovies(completion: @escaping(Result<[Tittle], (Error)>) -> Void)
        {
            guard let url = URL(string: "\(Constants.base_Url)/3/discover/movie?api_key=\(Constants.api_key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate")else{return}
            let task = URLSession.shared.dataTask(with: URLRequest(url: url))
            {data, _, error in guard let data = data, error == nil else
                {
                return
            }
                do{
                    let results = try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                    completion(.success(results.results))
                }
                catch
                {
                    completion(.failure(ApiError.failedTogetData))
                }
                }
            task.resume()
        }
    
    
    
    func search(with query: String,completion: @escaping(Result<[Tittle], (Error)>) -> Void)
    {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        
        guard let url = URL(string: "\(Constants.base_Url)/3/search/movie?api_key=\(Constants.api_key)&query=\(query)") else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, _, error in guard let data = data, error == nil else
            {
            return
        }
            do{
                let results = try JSONDecoder().decode(TrendingTittleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch
            {
                completion(.failure(ApiError.failedTogetData))
            }
            }
        task.resume()
    }
    
    
    func getMovies(with query: String,completion: @escaping(Result<VideoElement, (Error)>) -> Void)
    {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.Youtubebae_url)q=\(query)&key=\(Constants.Youtube_apiKey)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, _, error in guard let data = data, error == nil else
            {
            return
        }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            }
            catch
            {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            }
        task.resume()
    }
}

