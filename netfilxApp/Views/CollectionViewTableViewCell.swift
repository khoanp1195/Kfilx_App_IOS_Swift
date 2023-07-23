//
//  CollectionViewTableViewCell.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject{
    func collectionviewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let CollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout : layout )
        collectionView.register(TittleCollectionViewCell.self, forCellWithReuseIdentifier: TittleCollectionViewCell.identifier)
        return collectionView

    }()
  static let identifier = "CollectionViewTableViewCell"
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
    
    private func dowloadTittleAt(indexPath: IndexPath)
    {
        DataPersistanceManager.shared.DowloadTitleWith(model: titles[indexPath.row])
        {
            result in switch result {
            case .success():
                print("Dowloaded to Database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
//        apiCaller.shared.getMovies(with: titleName + "Trailer")
//        {
//            result in
//                switch result {
//                case.success(let videoElement):
//                    print(videoElement.id)
//                case.failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
        apiCaller.shared.getMovies(with: titleName + "Trailer"){[weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else{
                    return
                }
                let viewModel = TitlePreviewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionviewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
        { [weak self] _ in let dowloadAction = UIAction(title: "Dowload", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off){ _ in self?.dowloadTittleAt(indexPath: indexPath)}
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [dowloadAction])
        }
        return config
        }

}
