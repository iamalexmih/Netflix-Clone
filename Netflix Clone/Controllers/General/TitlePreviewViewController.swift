//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 19.09.2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    var movie: Movie?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Forest Gump"
        
       return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Best Film"
        
       return label
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        btn.setTitle("Download", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        
        return btn
    }()
    
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupView()
        setupConstraints()
    }
    
    func config(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }

    // MARK: - Button Actions
    
    private func btnTarget() {
        downloadBtn.addTarget(self, action: #selector(downloadBtnPress), for: .touchUpInside)
    }
    
    
    
    @objc func downloadBtnPress() {
        //guard let selectedMovie = selectedMovie else { return }
        //downloadBtnPressAction(with: selectedMovie)
    }
    
    
    private func downloadBtnPressAction(with: Movie) {
        
    }
    
    // MARK: - addSubview and setup Constraints
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadBtn)
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        downloadBtn.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25).isActive = true
        downloadBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        downloadBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    
}
