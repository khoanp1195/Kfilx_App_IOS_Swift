//
//  SearchResultViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 05/03/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject{
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewModel)
}

class SearchResultViewController: UIViewController {

    public var titles: [Tittle] = [Tittle]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultTitleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TittleCollectionViewCell.self,forCellWithReuseIdentifier: TittleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultTitleCollectionView)
        
        searchResultTitleCollectionView.delegate = self
        searchResultTitleCollectionView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultTitleCollectionView.frame = view.bounds
    }
}
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TittleCollectionViewCell.identifier, for: indexPath) as? TittleCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
            
            apiCaller.shared.getMovies(with: titleName){[weak self] result in
                switch result
                {
                case .success(let videoElement):
                    self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewModel(title: title.original_title ?? "", youtubeView: videoElement , titleOverview: title.overview ?? ""))
        
                case .failure(let error):
                    print(error.localizedDescription)
                }
                ;
            
        }

    }
    
}

