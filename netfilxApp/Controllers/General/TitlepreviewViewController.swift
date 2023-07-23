//
//  TitlepreviewViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 12/03/2023.
//

import UIKit
import WebKit

class TitlepreviewViewController: UIViewController {

    
    private let tittleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Phuong Khoa"
        label.textColor = .white
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid"
        label.textColor = .white
        return label
    }()
    
    private let dowloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Dowload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        view.addSubview(tittleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(dowloadButton)
        
        configureConstraint()
    }
    
    func configureConstraint()
    {
        let webviewConstraint = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 310)
        ]
        
        let tittleLabelConstraint = [
            tittleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant:  20),
            tittleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
        ]
        
        let overviewLabelConstraint =
        [
            overviewLabel.topAnchor.constraint(equalTo: tittleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        
        let dowloadbuttonConstraint =
        [
            dowloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dowloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            dowloadButton.widthAnchor.constraint(equalToConstant: 140),
            dowloadButton.heightAnchor.constraint(equalToConstant: 60),
        ]

        NSLayoutConstraint.activate(webviewConstraint)
        NSLayoutConstraint.activate(tittleLabelConstraint)
        NSLayoutConstraint.activate(overviewLabelConstraint)
        NSLayoutConstraint.activate(dowloadbuttonConstraint)
    }
    
    
    func  configure(with model: TitlePreviewModel) {
        tittleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")
        else{return}
        
        webView.load(URLRequest(url: url))
    }
 
}
