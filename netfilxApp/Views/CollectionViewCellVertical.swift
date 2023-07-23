//
//  CollectionViewTableViewCell.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

class CollectionViewCellVertical: UITableViewCell {

    private let CollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout : layout )
        collectionView.register(TittleCollectionViewCell.self, forCellWithReuseIdentifier: TittleCollectionViewCell.identifier)
        return collectionView

    }()
  static let identifier = "CollectionViewCellVertical"
    private var titles: [Tittle] = [Tittle]()
  
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemOrange
        
        contentView.addSubview(CollectionView)
        CollectionView.delegate = self
        CollectionView.dataSource = self
    }
    required init?(coder: NSCoder)
    {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CollectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Tittle]){
        self.titles = titles
        DispatchQueue.main.async {
            [weak self] in self?.CollectionView.reloadData()
        }
    }
    

}
extension CollectionViewCellVertical: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TittleCollectionViewCell.identifier, for: indexPath) as? TittleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
}
