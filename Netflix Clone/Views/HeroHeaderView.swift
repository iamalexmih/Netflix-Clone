//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 18.09.2022.
//

import UIKit

class HeroHeaderView: UIView {

    private let playBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Play", for: .normal)
        btn.layer.borderColor = UIColor.label.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Download", for: .normal)
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
    
        addSubview(playBtn)
        addSubview(downloadBtn)
        
        setConstraints()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
