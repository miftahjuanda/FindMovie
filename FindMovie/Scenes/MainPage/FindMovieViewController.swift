//
//  FindMovieViewController.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit

internal class FindMovieViewController: UIViewController {
    // MARK: - Properties
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.barTintColor = .lightGray
        search.searchBar.tintColor = .black
        search.searchBar.layer.cornerRadius = 12
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.placeholder = "Search"
        search.searchBar.backgroundColor = .white
        search.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        return search
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width/2) - 18,
                                 height: view.frame.width/1.6)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(MovieItemsCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieItemsCollectionViewCell.id)
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 8, left: 10, bottom: 0, right: 10)
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUiFindMovie()
    }
    
    private func setUiFindMovie() {
        view.endEditing(true)
        view.backgroundColor = .white
        
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(moviesCollectionView)
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension FindMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }
}

// MARK: - ColletionViewDataSource
extension FindMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemsCollectionViewCell.id,
                                                       for: indexPath)
        return cells
    }
}
