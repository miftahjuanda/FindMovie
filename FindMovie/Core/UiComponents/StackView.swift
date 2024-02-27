//
//  StackView.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit

@resultBuilder
internal struct StackBuilder {
    static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }
}

internal final class StackView: UIStackView {
    init(_ axisType: NSLayoutConstraint.Axis = .vertical, @StackBuilder views: () -> [UIView]) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = axisType
        views().forEach { [weak self] view in
            self?.addArrangedSubview(view)
        }
        layoutIfNeeded()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customSpacing(_ spacing: CGFloat, after: Int) -> StackView {
        setCustomSpacing(spacing, after: subviews[after])
        return self
    }
    
    func setAlignment(_ alignment: UIStackView.Alignment) -> StackView {
        self.alignment = alignment
        return self
    }
    
    func setDistribution(_ distribution: UIStackView.Distribution) -> StackView {
        self.distribution = distribution
        return self
    }
    
    func setSpacing(_ spacing: CGFloat) -> StackView {
        self.spacing = spacing
        return self
    }
    
    func setPadding(_ padding: UIEdgeInsets) -> StackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = padding
        return self
    }
}
