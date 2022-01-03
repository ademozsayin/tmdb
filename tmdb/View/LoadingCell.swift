//
//  LoadingCell.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import UIKit

class LoadingCell: UITableViewCell {

    
    var title = UILabel()
    var logo = UIImageView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
//        title = UILabel()
//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.font = UIFont(name: "SFProRounded-Semibold", size:  15.0)
//        title.text = "Loadng"
//        title.textColor = UIColor.init(hexString: "2B2D42")
        
        
        
        self.addSubviews([ logo])
        logo.setAnchorConstraintsFullSizeTo(view: self)
//        logo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
      
        
    }
       
}

extension LoadingCell {
    static let identifier = "LoadingCell"
}
