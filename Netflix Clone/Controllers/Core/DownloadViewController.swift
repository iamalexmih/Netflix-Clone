//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 17.09.2022.
//

import UIKit

class DownloadViewController: UIViewController {

    private var movies: [TitleItem] = []
    
    private let downloadTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        view.addSubview(downloadTableView)
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"),
                                               object: nil,
                                               queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadTableView.frame = view.bounds
    }
    
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchTitlesFromDataBase { [weak self] result in
            switch result {
                case .success(let movies):
                    self?.movies = movies
                    DispatchQueue.main.async {
                        self?.downloadTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension DownloadViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:

                DataPersistenceManager.shared.deleteTitleWith(model: movies[indexPath.row]) { result in
                    switch result {
                        case .success():
                            print("Delete from the Database")
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
                movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            @unknown default:
                break
        }
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
