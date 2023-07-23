//
//  TitleTableViewCell.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 04/03/2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

 static let identifier = "TitleTableViewCell"
    
    private let playtitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleName: UILabel = {
       let tittle = UILabel()
        tittle.translatesAutoresizingMaskIntoConstraints = false
        return tittle
    }()
    
    private let titlePosterImageView: UIImageView = {
        let titlePosterImageView = UIImageView()
        titlePosterImageView.contentMode = .scaleAspectFill
        titlePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        titlePosterImageView.clipsToBounds = true
        return titlePosterImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleName)
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(playtitleButton)
        
        applyConstraint()
    }
    
    private func applyConstraint()
    {
        let titlePosterImageViewConstraints = [
            titlePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100)
            ]
        let titleNameConstraints = [
            titleName.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 20),
            titleName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let playtitleButtonConstraints = [
            playtitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playtitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterImageViewConstraints)
        NSLayoutConstraint.activate(titleNameConstraints)
        NSLayoutConstraint.activate(playtitleButtonConstraints)
    }
    public func configure(with model: TittleViewModel)
    {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterUrl)")
        else{
            return
        }
        titlePosterImageView.sd_setImage(with: url,completed: nil)
        titleName.text = model.titleName
    }

    required init(coder: NSCoder) {
        fatalError()
    }
    

}
