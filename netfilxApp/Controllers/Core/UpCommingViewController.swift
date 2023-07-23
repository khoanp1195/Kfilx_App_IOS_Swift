//
//  UpCommingViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit



class UpCommingViewController: UIViewController {
    
    
    private var titles: [Tittle] = [Tittle]()
    private let comingfeedTable : UITableView =
    {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        comingfeedTable.frame = view.bounds
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(comingfeedTable)
        view.backgroundColor = UIColor.black
        comingfeedTable.delegate = self
        comingfeedTable.dataSource = self
        getTrendingMoview()
    }
    
    private func getTrendingMoview()
   {
       apiCaller.shared.getTrendingMovies{[weak self] result in
           switch result{
           case .success(let titles):
               self?.titles = titles
               DispatchQueue.main.async {
                   self?.comingfeedTable.reloadData()
               }
           case .failure(let error):
               print(error.localizedDescription)
           }
       }
   }

}

    extension UpCommingViewController: UITableViewDelegate, UITableViewDataSource{
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles .count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title
            
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
            
            guard let titleName = title.original_name ?? title.original_title else{return}
            
            apiCaller.shared.getMovies(with: titleName){[weak self] result in
                switch result{
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let vc = TitlepreviewViewController()
                        vc.configure(with: TitlePreviewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }

}
