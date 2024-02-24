//
//  MovieItemsCollectionViewCell.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit
import SnapKit
import Kingfisher

class MovieItemsCollectionViewCell: UICollectionViewCell {
    static let id = "MovieItemsCollectionViewCell"
    
    private let image = ImageView()
    private let titlelabel = LabelView("title", textColor: .black,
                                       font: .systemFont(ofSize: 13,
                                                         weight: .bold))
    private let subTitlelabel = LabelView("subTitle", textColor: .gray,
                                          lines: 1,
                                          font: .systemFont(ofSize: 12,
                                                            weight: .regular))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setuiCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: SearchEntity) {
        image.imageWithUrl(with: data.poster)
        titlelabel.text = data.title
        subTitlelabel.text = "Released in "+data.year
    }
    
    private func setuiCell() {
        clipsToBounds = true
        contentView.backgroundColor = .white.withAlphaComponent(0.6)
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.cornerRadius = 22
        
        titlelabel.lineBreakMode = .byWordWrapping
        subTitlelabel.lineBreakMode = .byWordWrapping
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
        
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.kf.cancelDownloadTask()
    }
}
