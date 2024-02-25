//
//  LabelView.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 24/02/24.
//

import UIKit

internal class LabelView: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 15)
        ])
    }
    
    @discardableResult
    func customLabel(_ text: String = "",
                     textColor: UIColor = .black,
                     backgroundColor: UIColor = .clear,
                     alignment: NSTextAlignment = .natural,
                     lines: Int = 0,
                     font: UIFont = .systemFont(ofSize: 12, weight: .regular)) -> LabelView {
        self.text = text
        self.numberOfLines = lines
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textAlignment = alignment
        self.font = font
        return self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
