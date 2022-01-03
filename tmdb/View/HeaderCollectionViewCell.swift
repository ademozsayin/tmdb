//
//  HeaderCollectionViewCell.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    var title = UILabel()
    var desc = UILabel()
    var bg = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        
       
        bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFill
        
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = UIFont(name: "SFProRounded-Bold", size:  20.0)
        
        desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont(name: "SFProRounded-Medium", size:  12.0)
        desc.textColor = .white
        desc.numberOfLines = 2
        
        self.addSubviews([bg,title,desc])
        
        bg.setAnchorConstraintsFullSizeTo(view: self)
        
        desc.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -40).isActive = true
        desc.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        desc.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true

        title.bottomAnchor.constraint(equalTo: desc.topAnchor,constant: -8).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true

    }
    
    func setData(movie:Movie) {
        self.title.text = movie.title
        self.desc.text = movie.overview
        if let poster = movie.posterPath  {
            let path = "https://image.tmdb.org/t/p/w500" + poster
            bg.download(url: path)
        }
    }
    
}

extension HeaderCollectionViewCell {
    static let identifier = "HeaderCollectionViewCell"
}
