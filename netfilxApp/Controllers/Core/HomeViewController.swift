//
//  HomeViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
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

    private var randomTrendingMovie: Tittle?
    
    private var headerView: MarvelHeaderUIView?
    
    
    let sectionTile: [String] = ["Trending Movies","New Movie","Action Movie"]
    
    private let homefeedTable : UITableView =
    {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(	CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    override func viewDidLayoutSubviews() {
        homefeedTable.frame = view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homefeedTable)
        view.backgroundColor = UIColor.black
        
        homefeedTable.delegate = self
        homefeedTable.dataSource = self
        
        headerView = MarvelHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homefeedTable.tableHeaderView = headerView
        configureNavbar()
        view.largeContentTitle = "Home"
        
        getTrendingMoview()
        configureHeroHeaderView()
    }
    
    //Configure header view random movies
    private func configureHeroHeaderView()
    {
        apiCaller.shared.getTrendingMovies{[weak self] result in
            switch result{
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TittleViewModel(titleName: selectedTitle?.original_title ?? "", posterUrl: selectedTitle?.poster_path ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
     
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url) 
        return true
    }

    private func configureNavbar()
    {
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done,target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"),style: .done,target: self,action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
    }
     private func getTrendingMoview()
    {
        apiCaller.shared.getTrendingMovies{results in
            switch results{
                case.success(let movies):
                        print(movies)
                case.failure(let error):
                        print(error)
            } 
        }
    }

    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTile.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    	
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello Anh Khoa"
//        return cell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath)
            as? CollectionViewTableViewCell else
        {
            return UITableViewCell()
        }
        
        cell.delegate = self
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                apiCaller.shared.getTrendingMovies{result in switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }}
            case Sections.TrendingTv.rawValue:
                apiCaller.shared.getTrendingTV{result in switch result{
                case .success(let tittles):
                    cell.configure(with: tittles)
                case .failure(let error):
                    print(error.localizedDescription)
                }}
            case Sections.Popular.rawValue:
                apiCaller.shared.getPopularMovies{result in switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }}
            
            case Sections.Upcoming.rawValue:
                apiCaller.shared.getUpcomingMovies{result in switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }}
            case Sections.TopRated.rawValue:
                apiCaller.shared.getTopRated{result in switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }}
            default:
                return UITableViewCell()
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTile[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,y: header.bounds.origin.y,width: 100,height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollview: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollview.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate
{
    func collectionviewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlepreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
