//
//  MovieCell.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import UIKit

class MovieCell: UITableViewCell {

    var poster = UIImageView()
    var title = UILabel()
    var detail = UILabel()
    var date = UILabel()
    var arrow = UIImageView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.backgroundColor = .gray
        poster.contentMode = .scaleAspectFill
        poster.layer.masksToBounds = true
        poster.layer.cornerRadius = 16
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "SFProRounded-Semibold", size:  15.0)
        title.text = "aa"
        title.textColor = UIColor.init(hexString: "2B2D42")
        
        detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.font = UIFont(name: "SFProRounded-Medium", size:  13.0)
        detail.textColor = UIColor.init(hexString: "8D99AE")
        detail.numberOfLines = 2
        detail.text = "asd"
        
        date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.text = "15.06.2021"
        date.font = UIFont(name: "SFProRounded-Regular", size:  12.0)
        date.textColor = UIColor.init(hexString: "8D99AE")

        arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(named: "arrow")
        
        self.addSubviews([poster, title, detail, date, arrow])
        
        poster.topAnchor.constraint(equalTo: self.topAnchor,constant: 16).isActive = true
        poster.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        poster.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 104).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor,constant: 24).isActive = true
        title.leadingAnchor.constraint(equalTo: poster.trailingAnchor,constant: 8).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -44).isActive = true
        
        detail.topAnchor.constraint(equalTo: self.title.bottomAnchor,constant: 8).isActive = true
        detail.leadingAnchor.constraint(equalTo: self.title.leadingAnchor).isActive = true
        detail.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -44).isActive = true
        
        date.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -44).isActive = true
        date.bottomAnchor.constraint(equalTo: self.poster.bottomAnchor).isActive = true
        
        arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let divider = UILabel()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.init(hexString: "E9ECEF")
        self.addSubview(divider)
        
        divider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setData(_ movie: Movie ) {
        self.title.text = movie.niceTitle()
        self.detail.text = movie.overview ?? ""
        self.date.text = movie.releaseDate ?? ""
    }
   
}

extension MovieCell {
    static let identifier = "MovieCell"
}
