//
//  Extensions.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation
import UIKit
import SDWebImage

extension UIView {
    
    func setAnchorConstraintsFullSizeTo(view: UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach({ self.addSubview($0)})
    }
   
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {

    class func hexStringToColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    //Get UIColor by hex
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}


extension UIImageView {
    func download(url:String){
      //remove space if a url contains.
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }

}


extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        return shared.statusBarFrame.height
    }
}

struct ScreenUtils {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.statusBarHeight
    }
}


protocol AttributedStringComponent {
    var text: String { get }
    func getAttributes() -> [NSAttributedString.Key: Any]?
}

// MARK: String extensions

extension String: AttributedStringComponent {
    var text: String { self }
    func getAttributes() -> [NSAttributedString.Key: Any]? { return nil }
}

extension String {
    func toAttributed(with attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
        .init(string: self, attributes: attributes)
    }
}

// MARK: NSAttributedString extensions

extension NSAttributedString: AttributedStringComponent {
    var text: String { string }

    func getAttributes() -> [Key: Any]? {
        if string.isEmpty { return nil }
        var range = NSRange(location: 0, length: string.count)
        return attributes(at: 0, effectiveRange: &range)
    }
}

extension NSAttributedString {

    convenience init?(from attributedStringComponents: [AttributedStringComponent],
                      defaultAttributes: [NSAttributedString.Key: Any],
                      joinedSeparator: String = " ") {
        switch attributedStringComponents.count {
        case 0: return nil
        default:
            var joinedString = ""
            typealias SttributedStringComponentDescriptor = ([NSAttributedString.Key: Any], NSRange)
            let sttributedStringComponents = attributedStringComponents.enumerated().flatMap { (index, component) -> [SttributedStringComponentDescriptor] in
                var components = [SttributedStringComponentDescriptor]()
                if index != 0 {
                    components.append((defaultAttributes,
                                       NSRange(location: joinedString.count, length: joinedSeparator.count)))
                    joinedString += joinedSeparator
                }
                components.append((component.getAttributes() ?? defaultAttributes,
                                   NSRange(location: joinedString.count, length: component.text.count)))
                joinedString += component.text
                return components
            }

            let attributedString = NSMutableAttributedString(string: joinedString)
            sttributedStringComponents.forEach { attributedString.addAttributes($0, range: $1) }
            self.init(attributedString: attributedString)
        }
    }
}

extension Date {
    func yearAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("YYYY")
            return df.string(from: self)
    }
}


extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "yyyy-MM-dd") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr-TR")
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
