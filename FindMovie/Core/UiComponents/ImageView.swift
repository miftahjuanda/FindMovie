//
//  ImageView.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit
import SnapKit
import Kingfisher

internal final class ImageView: UIImageView {
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.tintColor = .darkGray
        indicator.stopAnimating()
        return indicator
    }()
    
    init() {
        super.init(frame: .zero)
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageView() {
        clipsToBounds = true
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func imageWithUrl(with imageURL: String) {
        loadingIndicator.startAnimating()
        guard let url = URL(string: imageURL) else { return }
        kf.setImage(with: url, placeholder: nil, options: nil) { result in
            self.loadingIndicator.stopAnimating()
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.image = UIImage(named: "DataEmptyIcon")
                break
            }
        }
    }
}
