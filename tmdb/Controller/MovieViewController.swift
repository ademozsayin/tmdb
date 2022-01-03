//
//  ViewController.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import UIKit

class MovieViewController: UIViewController {

    // MARK: - VARS
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 136.0
        view.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        view.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        view.register(MovieHeader.self, forHeaderFooterViewReuseIdentifier: MovieHeader.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    var pageIndex: Int = 1
    var totalpages:Int = 0
    var isLoading:Bool = false
    var movies:[Movie] = [] {
        didSet {
            print(movies.count)
        }
    }
    
    var nowPlaying:[Movie] = []
    
    // MARK: - LIFECYCLES
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPlaying()
        fetchUpcoming(page: pageIndex,isRefresh: false)

    }
    
    // MARK: - NOW PLAYING REQ
    private func fetchPlaying() {
        MovieAPI().nowPlaying { [ weak self] result in
            switch result {
            case .success(let res):
                self?.nowPlaying = res.data ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let err):
              print(err)
            }
        }
    }
    
    // MARK: - Fetch Upcoming  movies
    private func fetchUpcoming(page:Int, isRefresh:Bool) {
        isLoading = true
        MovieAPI().upcoming(page:page) { [weak self] result  in
            switch result {
            case .success(let res):
                if isRefresh {
                    self?.movies = res.data ?? []
                    self?.totalpages = res.totalPages ?? 1
                } else {
                    self?.movies.append(contentsOf: res.data ?? [])
                    self?.totalpages = res.totalPages ?? 1
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.refreshControl.endRefreshing()
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let err):
              debugPrint(err)
                self?.alert(message: err.localizedDescription, title: "Opps!")
            }
        }
    }
    
    // MARK: - Moview Detail page redirect
    private func showDetails(_ movie:Movie?) {
        guard let movie = movie else { return }
        let vc = MovieDetailsViewController()
        vc.setData(movie: movie)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Pull to refresh
    @objc func refresh(_ sender: AnyObject) {
        fetchUpcoming(page: 1, isRefresh:true)
    }
}

// MARK: - UI

extension MovieViewController {
    private func setupView() {
        view.addSubview(tableView)
        tableView.setAnchorConstraintsFullSizeTo(view: view)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
}
// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return movies.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let movie = movies[indexPath.row]
            cell.setData(movie)
            
            if let poster = movie.posterPath  {
                let path = "https://image.tmdb.org/t/p/w500" + poster
                cell.poster.download(url: path)
            }
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
//            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 136.0 //Item Cell height
        } else {
            if pageIndex < totalpages {
                return 45 //Loading Cell height
            } else {
                return 0 //Loading Cell height
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        showDetails(movie)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 256
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MovieHeader.identifier) as! MovieHeader
            headerView.delegate = self
            headerView.setPlaying(movies: self.nowPlaying)
            return headerView
        } else {
            return UIView()
        }
   
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLoading {
            return
        }
        if pageIndex < totalpages {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if offsetY > contentHeight - scrollView.frame.size.height {
                pageIndex += 1
                fetchUpcoming(page: pageIndex,isRefresh: false)
            }
        } else {
            return
        }
    }
}

// MARK: - MovieHeaderProtocol

extension MovieViewController:MovieHeaderProtocol {

    func didTappedMovie(_ movie: Movie?) {
        showDetails(movie)
    }
}

