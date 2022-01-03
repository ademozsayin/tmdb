//
//  ViewController.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import UIKit

class MovieViewController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 136.0
        view.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        view.register(MovieHeader.self, forHeaderFooterViewReuseIdentifier: MovieHeader.identifier)

        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private let downloader = ImageDownloader()
    
    var movies:[Movie] = []
    var nowPlaying:[Movie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.setAnchorConstraintsFullSizeTo(view: view)
        fetchPlaying()
        fetchUpcoming()

    }
    
    private func fetchPlaying() {
        MovieAPI().nowPlaying { result in
            switch result {
            case .success(let res):
                self.nowPlaying = res.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
              print(err)
            }
        }
    }
    
    
    private func fetchUpcoming() {
        MovieAPI().upcoming { result  in
           
            switch result {
            case .success(let res):
                self.movies = res.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
              print(err)
            }
        }
    }
    
    private func showDetails(_ movie:Movie?) {
        guard let movie = movie else { return }
        let vc = MovieDetailsViewController()
        vc.setData(movie: movie)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.setData(movie)
        
        if let poster = movie.posterPath  {
            let path = "https://image.tmdb.org/t/p/w500" + poster
            cell.poster.download(url: path)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        showDetails(movie)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 256  // or whatever
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MovieHeader.identifier) as! MovieHeader
        headerView.delegate = self
        headerView.setPlaying(movies: self.nowPlaying)
        return headerView
    }
    
}

// MARK: - MovieHeaderProtocol

extension MovieViewController:MovieHeaderProtocol {

    func didTappedMovie(_ movie: Movie?) {
        showDetails(movie)
    }
    
}
