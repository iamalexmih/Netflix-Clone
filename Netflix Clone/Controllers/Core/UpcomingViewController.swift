//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 17.09.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var movies: [Movie] = []
    
    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white

        view.addSubview(upcomingTableView)
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcoming()
    }
  
    
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { result in
            switch result {
                case .success(let movies):
                    self.movies = movies
                    DispatchQueue.main.async { [weak self] in
                        self?.upcomingTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.config(with: TitleViewModel(titleName: movie.original_name ??
                                         movie.original_title ??
                                         "Unknown title name",
                                         posterURL: movie.poster_path ?? ""))
        
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
