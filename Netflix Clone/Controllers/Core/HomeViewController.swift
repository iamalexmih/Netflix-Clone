//
//  HomeViewController.swift
//  Netflix Clone
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {

    let sectionTitle: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    private var randomTrendingMovie: Movie?
    private var headerView: HeroHeaderView?
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self,
                           forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(homeFeedTable)
        
        view.backgroundColor = .systemBackground
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        headerView?.delegate = self
        configHeroHeaderView()
        
        configNavBar()
        
        getTrendingMovies()
    }
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
                case .success(let movies):
                    guard let selectedMovie = movies.randomElement() else { return }
                    self?.randomTrendingMovie = selectedMovie
                    self?.headerView?.config(with: TitleViewModel(titleName: selectedMovie.original_title ?? "",
                                                                  posterURL: selectedMovie.poster_path ?? ""))
                    self?.headerView?.setSelectMovie(with: selectedMovie)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func configNavBar() {
        var image = UIImage(named: "netflix_Logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    func getTrendingMovies() {
        APICaller.shared.getTrendingMovies { _ in
            
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,
                                                       for: indexPath) as? CollectionViewTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                APICaller.shared.getTrendingMovies { result in
                    switch result {
                        case .success(let movies):
                            cell.config(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case Sections.TrendingTv.rawValue:
                APICaller.shared.getTrendingTvs { result in
                    switch result {
                        case .success(let movies):
                            cell.config(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case Sections.Popular.rawValue:
                APICaller.shared.getPopularMovies { result in
                    switch result {
                        case .success(let movies):
                            cell.config(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case Sections.Upcoming.rawValue:
                APICaller.shared.getUpcomingMovies { result in
                    switch result {
                        case .success(let movies):
                            cell.config(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case Sections.TopRated.rawValue:
                APICaller.shared.getTopRatedMovies { result in
                    switch result {
                        case .success(let movies):
                            cell.config(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            default:
                return UITableViewCell()
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.config(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
