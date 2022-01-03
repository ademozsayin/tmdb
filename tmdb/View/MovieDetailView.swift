//
//  MovieDetailView.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import UIKit

class MovieDetailView: UIView {

//    var scrollView = UIScrollView()
    var poster = UIImageView()
    var title = UILabel()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var imdb = UIImageView()
    var rateView = RateView()
    var dateLabel = UILabel()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.sizeToFit()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProRounded-Bold", size:  20.0)
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProRounded-Regular", size:  15.0)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupScrollView()
        setupViews()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
                
    func setupViews(){
        
        poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.backgroundColor = .gray
        poster.contentMode = .scaleAspectFill
        contentView.addSubview(poster)
        
        poster.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        poster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        imdb = UIImageView()
        imdb.translatesAutoresizingMaskIntoConstraints = false
        imdb.image = UIImage(named: "imdb")
        contentView.addSubview(imdb)
        imdb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16).isActive = true
        imdb.topAnchor.constraint(equalTo: poster.bottomAnchor,constant: 16).isActive = true

        rateView = RateView()
        rateView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rateView)
        rateView.leadingAnchor.constraint(equalTo: imdb.trailingAnchor,constant: 8).isActive = true
        rateView.centerYAnchor.constraint(equalTo: imdb.centerYAnchor).isActive = true
        
        let point = UIView()
        point.translatesAutoresizingMaskIntoConstraints = false
        point.layer.masksToBounds = true
        point.layer.cornerRadius = 2
        point.backgroundColor = UIColor.init(hexString: "#E6B91E")
        contentView.addSubview(point)
        
        point.leadingAnchor.constraint(equalTo: imdb.trailingAnchor,constant: 74).isActive = true
        point.centerYAnchor.constraint(equalTo: imdb.centerYAnchor).isActive = true
        point.widthAnchor.constraint(equalToConstant: 4).isActive = true
        point.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "SFProRounded-Medium", size:  13.0)
        contentView.addSubview(dateLabel)
        dateLabel.textColor = UIColor(named: "2B2D42")
        dateLabel.leadingAnchor.constraint(equalTo: point.trailingAnchor,constant: 10).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: imdb.centerYAnchor).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imdb.bottomAnchor,constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true

        contentView.addSubview(subtitleLabel)
        subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                
    }
    
    func setDetail(_ movie:Movie){
        self.titleLabel.text = movie.niceTitle()
        self.subtitleLabel.text = movie.overview
        self.rateView.setData(txt: movie.voteAverage)
        self.dateLabel.text = movie.releaseDate
        if let poster = movie.backdropPath  {
            let path = "https://image.tmdb.org/t/p/w500" + poster
            self.poster.download(url: path)
        }
    }
}

