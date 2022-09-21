//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 17.09.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private var movies: [Movie] = []
    
    private let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        return tableView
    }()
    
    private let searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        
        return searchController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        fetchDiscoverMovies()
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
    }

    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { result in
            switch result {
                case .success(let movies):
                    self.movies = movies
                    DispatchQueue.main.async { [weak self] in
                        self?.discoverTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTableView.frame = view.bounds
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                               for: indexPath) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        let modelMovie = TitleViewModel(titleName: movie.original_name ??
                                        movie.original_title ??
                                        "Unknown name",
                                        posterURL: movie.poster_path ?? "")
        cell.config(with: modelMovie)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name
        else { return }
        
        APICaller.shared.getTrailerYoutube(with: movieName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let viewModel = TitlePreviewViewModel(title: movieName,
                                                              youtubeView: videoElement,
                                                              titleOverview: movie.overview ?? "")
                        let vc = TitlePreviewViewController()
                        vc.config(with: viewModel)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.config(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController
        else {
            return
        }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                    case .success(let movies):
                        resultsController.movies = movies
                        resultsController.searchResultsCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}
