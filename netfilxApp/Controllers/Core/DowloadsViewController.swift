//
//  DowloadsViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

class DowloadsViewController: UIViewController {

    private var titles:[TitleItem] = [TitleItem]()
    
    private let dowloadedTable : UITableView =
    {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Dowloaded"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        dowloadedTable.delegate = self
        dowloadedTable.dataSource = self
        view.addSubview(dowloadedTable)
        fetchlocalStorageforDowload()
    }
    
    private func fetchlocalStorageforDowload()
    {
        DataPersistanceManager.shared.fetchingTitleFromData{[weak self] result in switch result{
        case .success(let titles):
            self?.titles = titles
            DispatchQueue.main.async {
                self?.dowloadedTable.reloadData()
            }
        case .failure(let error):
            print(error.localizedDescription)
        }        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dowloadedTable.frame = view.bounds
    }
}
extension DowloadsViewController: UITableViewDelegate, UITableViewDataSource
{
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
          //  tableView.deleteRows(at: [indexPath], with: .fade)
            DataPersistanceManager.shared.DeleteData(model: titles[indexPath.row]){
             [weak self] result in switch result
                {
                case .success():
                    print("delete item success")
                    
                case . failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
            
        }
    }
    
}
