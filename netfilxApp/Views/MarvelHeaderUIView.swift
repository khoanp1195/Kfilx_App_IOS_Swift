//
//  MarvelHeaderUIView.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

class MarvelHeaderUIView: UIView {

    private let dowaloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dowload", for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("play", for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "marvel")
        return imageView
    }()
    
    private func adGradient()
    {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientlayer.frame = bounds
        layer.addSublayer(gradientlayer)
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(heroImageView)
        adGradient()
        addSubview(playButton)
        addSubview(dowaloadButton)
        applyConstraint()
    }
    private func applyConstraint()
    {
        let playbuttonConstraint = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
            
        ]
        let dowloadbuttonConstraint = [
            dowaloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            dowaloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            dowaloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(dowloadbuttonConstraint)
        NSLayoutConstraint.activate(playbuttonConstraint)
        
    }
    
    public func configure(with model: TittleViewModel)
    {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterUrl)")
        else{
            return
        }
        heroImageView.sd_setImage(with: url,completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    required init?(coder: NSCoder)
    {
        fatalError()
    }

}
