//
//  MovieItemsCollectionViewCell.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit
import SnapKit
import Kingfisher
import ShimmerView

class MovieItemsCollectionViewCell: UICollectionViewCell {
    static let id = "MovieItemsCollectionViewCell"
    
    private let image = ImageView()
    private var titlelabel = LabelView()
    private var subTitlelabel = LabelView()
    private var shimmer = ShimmerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setuiCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: SearchEntity) {
        if data.isLoading {
            setShimmerView()
        } else {
            shimmer.stopAnimating()
            titlelabel.customLabel(data.title,
                                   textColor: .black,
                                   font: .systemFont(ofSize: 13,
                                                     weight: .bold))
            subTitlelabel.customLabel("Released in "+data.year,
                                      textColor: .gray,
                                      lines: 1,
                                      font: .systemFont(ofSize: 12,
                                                        weight: .regular))
            image.imageWithUrl(with: data.poster)
        }
    }
    
    private func setShimmerView() {
        image.image = UIImage(systemName: "photo.fill")?.withTintColor(.lightGray.withAlphaComponent(0.5),
                                                                       renderingMode: .alwaysOriginal)
        titlelabel.customLabel("-",
                               textColor: .clear,
                               backgroundColor: .lightGray.withAlphaComponent(0.5))
        
        subTitlelabel.customLabel("-",
                                  textColor: .clear,
                                  backgroundColor: .lightGray.withAlphaComponent(0.5))
        
        shimmer.startAnimating()
    }
    
    private func setuiCell() {
        clipsToBounds = true
        contentView.backgroundColor = .white.withAlphaComponent(0.6)
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.cornerRadius = 22
        
        titlelabel.contentHuggingPriority(for: .vertical)
        titlelabel.lineBreakMode = .byWordWrapping
        subTitlelabel.lineBreakMode = .byWordWrapping
        subTitlelabel.contentHuggingPriority(for: .horizontal)
        image.layer.cornerRadius = 8
        
        let mainStack = StackView {
            image
            titlelabel
            subTitlelabel
        }.setPadding(.init(top: 8, left: 8,
                           bottom: 8, right: 8))
        
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints({ make in
            make.top.leading.trailing.bottom.equalToSuperview()
        })
        
        mainStack.setCustomSpacing(8, after: mainStack.subviews[0])
        mainStack.setCustomSpacing(1, after: mainStack.subviews[1])
        
        shimmer.style = .init(baseColor: .clear, highlightColor: .lightGray.withAlphaComponent(0.13),
                              duration: 0.7, interval: 0.3, effectSpan: .points(150), effectAngle: 0 * CGFloat.pi)
        contentView.addSubview(shimmer)
        shimmer.snp.makeConstraints({ make in
            make.top.leading.trailing.bottom.equalToSuperview()
        })
        
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.kf.cancelDownloadTask()
    }
}
