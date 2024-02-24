//
//  FindMovieViewController.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit

internal class FindMovieViewController: UIViewController {
    // MARK: - Properties
    private var cancellables = CancelBag()
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
        return collectionView
    }()
    
//    SearchEntity
    private lazy var dataSource = UICollectionViewDiffableDataSource<String, SearchEntity>(collectionView: moviesCollectionView) { [weak self] (collectionView, indexPath, value) -> UICollectionViewCell? in
        guard let self = self else { return UICollectionViewCell() }
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemsCollectionViewCell.id,
                                                       for: indexPath) as? MovieItemsCollectionViewCell)!
        cell.setData(value)
        return cell
    }
    
    private var viewModel: FindMovieViewModelProtocol
    
    init(viewModel: FindMovieViewModelProtocol = FindMovieViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUiFindMovie()
        bindData()
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
    
    private func bindData() {
        self.viewModel.viewType
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveValue: {[unowned self] state in
                self.renderView(state)
            }).store(in: cancellables)
    }
    
    private func renderView(_ viewType: ViewTypes<[SearchEntity]>) {
        switch viewType {
        case .loading:
            print("Loading")
        case .success(let data):
            applySnapshot(items: data)
        case .noResults:
            print("Data nil")
        case .failure(let fail):
            print("Failure: ", fail)
        }
    }
}

// MARK: - UISearchBarDelegate
extension FindMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let keyword = searchBar.text {
            viewModel.findMovie(keyword: keyword)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }
}

// MARK: - DataSource
extension FindMovieViewController {
    private func applySnapshot(items: [SearchEntity], animatingDifferences: Bool = true) {
        var snapshot: NSDiffableDataSourceSnapshot<String, SearchEntity> = .init()
        snapshot.appendSections([""])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
