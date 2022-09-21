//
//  SearchResultViewController.swift
//  Netflix Clone
//


import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    public var movies: [Movie] = []
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier,
                                                      for: indexPath) as? MovieCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        cell.config(with: movie.poster_path ?? "")
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name
        else { return }
        
        APICaller.shared.getTrailerYoutube(with: movieName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let videoElement):
                        let viewModel = TitlePreviewViewModel(title: movieName,
                                                              youtubeView: videoElement,
                                                              titleOverview: movie.overview ?? "")
                        self.delegate?.searchResultViewControllerDidTapItem(viewModel)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
    }
}
