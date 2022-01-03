//
//  MovieHeader.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import UIKit

protocol MovieHeaderProtocol:AnyObject {
    func didTappedMovie(_ movie: Movie?)
}

class MovieHeader: UITableViewHeaderFooterView {

    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var movies: [Movie] = []
    
    var pageControl = UIPageControl()

    weak var delegate:MovieHeaderProtocol? = nil
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.frame.width, height: 256)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
//        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
        collectionView.setAnchorConstraintsFullSizeTo(view: contentView)
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .black.withAlphaComponent(0.1)
//        pageControl.backgroundStyle = .prominent
        pageControl.currentPage = 0
        contentView.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
       
    }
    
    func setPlaying(movies: [Movie]) {
        self.movies = movies
        pageControl.numberOfPages = movies.count > 5 ? movies.prefix(5).count : movies.count
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension MovieHeader:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count > 5 ? movies.prefix(5).count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as! HeaderCollectionViewCell
        let movie = movies[indexPath.row]
        cell.setData(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let delegate = self.delegate{
            delegate.didTappedMovie(movie)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            targetContentOffset.pointee = scrollView.contentOffset
            
            //M: Get the first visiable item's indexPath from visibaleItems.
            var indexPaths = collectionView.indexPathsForVisibleItems
            indexPaths.sort()
            var indexPath = indexPaths.first!

            //M: Use the velocity to detect the paging control movement.
            //M: If the movement is forward, then increase the indexPath.
            if velocity.x > 0{
                indexPath.row += 1
                
                //M: If the movement is in the next section, which means the indexPath's row is out range. We set the indexPath to the first row of the next section.
                if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section){
                    indexPath.row = 0
                    indexPath.section += 0
                }
            }
            else{
                //M: If the movement is backward, the indexPath will be automatically changed to the first visiable item which is indexPath.row - 1. So there is no need to write the logic.
            }
            
            //M: Tell the collection view to scroll to the next item.
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true )
     }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MovieHeader: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width ,height: self.frame.size.height)
    }
}

extension MovieHeader {
    static let identifier = "MovieHeader"
}

