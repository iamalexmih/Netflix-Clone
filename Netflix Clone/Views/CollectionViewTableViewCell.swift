//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 17.09.2022.
//

import UIKit


protocol CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(viewModel: TitlePreviewViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {

    var delegate: CollectionViewTableViewCellDelegate?
    
    static let identifier = "CollectionViewTableViewCell"
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()

    
    public func config(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    private func downloadMovieAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadTitleWith(model: movies[indexPath.row]) { result in
            switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView Delegate and DataSource

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier,
                                                      for: indexPath) as? MovieCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        guard let posterPath = movies[indexPath.row].poster_path
        else {
            return UICollectionViewCell()
        }
        cell.config(with: posterPath)
        
        return cell
    }
    
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name
        else { return }
        
        APICaller.shared.getTrailerYoutube(with: movieName + " trailer") { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let videoElement):
                    let viewModel = TitlePreviewViewModel(title: movieName,
                                                          youtubeView: videoElement,
                                                          titleOverview: movie.overview ?? "")
                    self.delegate?.collectionViewTableViewCellDidTapCell(viewModel: viewModel)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Long tap on Cell, contextMenuConfigurationForItemAt
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          image: nil,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { action in
                self?.downloadMovieAt(indexPath: indexPath)
            }
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [downloadAction])
        }
        return config
    }
}
