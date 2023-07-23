//
//  SearchViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Tittle] = [Tittle]()
    private let searchTable : UITableView =
    {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movive or TV Show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
        navigationItem.searchController = searchController
        view.addSubview(searchTable)
        view.backgroundColor = UIColor.black
        searchTable.delegate = self
        searchTable.dataSource = self
        getDiscoverMovie()
        
        searchController.searchResultsUpdater = self
        
    }

    private func getDiscoverMovie()
    {
        apiCaller.shared.getDiscoverMovies{[weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles .count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TittleViewModel(titleName: (title.original_name ?? title.original_title) ?? "Unknown Name", posterUrl: title.poster_path ?? "Unknown Path"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let tittleName = title.original_name ?? title.original_title else {return}
        
        apiCaller.shared.getMovies(with: tittleName){[weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlepreviewViewController()
                    vc.configure(with: TitlePreviewModel(title: tittleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
}
extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate
{
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        
        guard let query =  searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
                let resultsController = searchController.searchResultsController as? SearchResultViewController else{
            return
        }
        resultsController.delegate = self
        apiCaller.shared.search(with: query)
        {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultTitleCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlepreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

