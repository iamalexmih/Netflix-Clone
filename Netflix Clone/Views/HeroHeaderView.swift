//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 18.09.2022.
//

import UIKit

class HeroHeaderView: UIView {

    var delegate: CollectionViewTableViewCellDelegate?
    var selectedMovie: Movie?
    
    private let playBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Play", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        btn.tintColor = .white
        btn.layer.borderColor = UIColor.label.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Download", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        btn.tintColor = .white
        btn.layer.borderColor = UIColor.label.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_hero_header")
        
        return imageView
    }()
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()

        addSubview(playBtn)
        addSubview(downloadBtn)
        
        setConstraints()
        btnTarget()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
    }
    
    
    public func config(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        heroImageView.sd_setImage(with: url)
    }
    
    
    func setSelectMovie(with model: Movie) {
        selectedMovie = model
    }
    
    
    private func setConstraints() {
        playBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60).isActive = true
        playBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        downloadBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60).isActive = true
        downloadBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        downloadBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    
    // MARK: - Button Actions
    
    private func btnTarget() {
        playBtn.addTarget(self, action: #selector(playBtnPress), for: .touchUpInside)
        downloadBtn.addTarget(self, action: #selector(downloadBtnPress), for: .touchUpInside)
    }
    
    
    
    @objc func playBtnPress() {
        guard let selectedMovie = selectedMovie else { return }
        playBtnPressAction(with: selectedMovie)
    }
    

    
    private func playBtnPressAction(with model: Movie) {
        let movieName = model.original_name ?? model.original_title ?? ""
        
        APICaller.shared.getTrailerYoutube(with: movieName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let viewModel = TitlePreviewViewModel(title: movieName,
                                                              youtubeView: videoElement,
                                                              titleOverview: model.overview ?? "")
                        self.delegate?.collectionViewTableViewCellDidTapCell(viewModel: viewModel)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    
    
    @objc func downloadBtnPress() {
        guard let selectedMovie = selectedMovie else { return }
        downloadBtnPressAction(with: selectedMovie)
    }
    
    
    
    
    private func downloadBtnPressAction(with model: Movie) {
        DataPersistenceManager.shared.downloadTitleWith(model: model) { result in
            switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
