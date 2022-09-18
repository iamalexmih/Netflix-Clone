//
//  APICaller.swift
//  Netflix Clone
//


import Foundation


struct Constants {
    static let baseUrl = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Tv], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Tv], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    func getPopularMovies(completion: @escaping (Result<[Tv], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    func getTopRatedMovies(completion: @escaping (Result<[Tv], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
