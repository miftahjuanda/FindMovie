//
//  FindMovieViewController.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit
import ShimmerView

internal class FindMovieViewController: UIViewController {
    // MARK: - Properties
    private var cancellables = CancelBag()
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.barTintColor = .lightGray
        search.searchBar.tintColor = .black
        search.searchBar.layer.cornerRadius = 12
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.placeholder = "Find your movie"
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
        collectionView.contentInset = .init(top: 8, left: 10, bottom: 0, right: 10)
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<String, SearchEntity>(collectionView: moviesCollectionView) { [weak self] (collectionView, indexPath, value) -> UICollectionViewCell? in
        guard let self = self else { return UICollectionViewCell() }
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemsCollectionViewCell.id,
                                                       for: indexPath) as? MovieItemsCollectionViewCell)!
        cell.setData(value)
        return cell
    }
    
    private var networkManager = NetworkReachability.shared
    private var viewModel: FindMovieViewModelProtocol
    
    init(viewModel: FindMovieViewModelProtocol = FindMovieViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        networkManager.stopMonitoring()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUiFindMovie()
        bindData()
        observeNetwork()
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
        
        viewModel.initialData()
    }
    
    private func renderView(_ viewType: ViewTypes<[SearchEntity]>) {
        switch viewType {
        case .loading:
            DispatchQueue.main.async {
                self.applySnapshot(items: [SearchEntity(), SearchEntity(), SearchEntity(),
                                      SearchEntity(), SearchEntity(), SearchEntity()])
            }
        case .success(let data):
            DispatchQueue.main.async {
                self.applySnapshot(items: data)
            }
        case .noResults:
            showError(title: "Not Found",
                      message: "Sorry, no results were found for this keyword.",
                      isReload: false)
        case .failure(let fail):
            print("Failure: ", fail)
            showError(title: "Something wrong",
                      message: fail)
        }
    }
    
    private func observeNetwork() {
        networkManager.startMonitoring { [weak self] updates in
            guard let self = self else { return }
            
            if !updates {
                showError(title: "Connection Lost", message: "Please check your connection and try again.", isReload: false)
            }
        }
    }
    
    private func showError(title: String, message: String, isReload: Bool = true) {
        DispatchQueue.main.async {
            self.presentPopup(title: title,
                              message: message) {
                if isReload {
                    self.viewModel.reloadSearch()
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension FindMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let keyword = searchBar.text {
            self.searchBar.isActive = false
            self.searchBar.searchBar.text = keyword
            viewModel.findMovie(keyword: keyword)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }
}

// MARK: - CollectionView DataSource and Delegate
extension FindMovieViewController: UICollectionViewDelegateFlowLayout {
    private func applySnapshot(items: [SearchEntity], animatingDifferences: Bool = true) {
        var snapshot: NSDiffableDataSourceSnapshot<String, SearchEntity> = .init()
        snapshot.appendSections([""])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if !viewModel.isFetchPagination && (offsetY > contentHeight - height) {
            viewModel.pagination()
        }
    }
}
