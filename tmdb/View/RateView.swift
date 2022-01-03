//
//  RateView.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import UIKit

class RateView: UIView {

    var icon = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "rate")
       
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProRounded-Medium", size:  13.0)
        self.addSubviews([icon, label])
        
        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor,constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
       


    }
    
    func setData(txt:Double?) {
        guard let rate = txt else { return }
        let rateString = "\(rate)"
        let defaultAttributes = [
            .font: UIFont(name: "SFProRounded-Medium", size:  13.0) as Any,
            .foregroundColor: UIColor.black
        ] as [NSAttributedString.Key : Any]

        let marketingAttributes = [
            .font: UIFont(name: "SFProRounded-Medium", size:  13.0) as Any,
            .foregroundColor: UIColor.init(hexString: "ADB5BD")
        ] as [NSAttributedString.Key : Any]

        let attributedStringComponents = [
            rateString,
            NSAttributedString(string: "/10", attributes: marketingAttributes)
        ] as [AttributedStringComponent]
        let attributedText = NSAttributedString(from: attributedStringComponents, defaultAttributes: defaultAttributes)
        label.attributedText = attributedText
    }
    
    

}
