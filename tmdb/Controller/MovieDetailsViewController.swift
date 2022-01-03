//
//  MovieDetailsViewController.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import UIKit
import SVProgressHUD

class MovieDetailsViewController: UIViewController {

    var detailView = MovieDetailView()
    
    var movie:Movie? {
        didSet {
            if let movie = movie {
                self.movie = movie
                DispatchQueue.main.async {
                    self.title = movie.title ?? ""
                    self.detailView.setDetail(movie)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        image?.withTintColor(.black)
        let backBTN = UIBarButtonItem(image: image,
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        let attributes = [NSAttributedString.Key.font: UIFont(name: "SFProRounded-Bold", size: 11)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailView = MovieDetailView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: view.topAnchor,constant: ScreenUtils.statusBarHeight + topbarHeight).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    func setData(movie:Movie) {
        SVProgressHUD.show()
        guard let id = movie.id else {
            SVProgressHUD.dismiss()
            return
        }
        
        MovieAPI().getMovieDetail(id: id) { result in
            SVProgressHUD.dismiss()
            
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let err):
              print(err)
            }
        }
    }


}
