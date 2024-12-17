//
//  DRxEmptyView.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit

/// 空视图协议
public protocol DRxEmptyViewProtocol: UIView {
    /// 更新状态
    func update(state: DRxEmptyViewState)
}

/// 默认空视图
open class DRxEmptyView: UIView, DRxEmptyViewProtocol {
    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - DRxEmptyViewProtocol
    
    open func update(state: DRxEmptyViewState) {
        switch state {
        case .none:
            isHidden = true
            activityIndicator.stopAnimating()
            
        case .empty(let message):
            isHidden = false
            activityIndicator.stopAnimating()
            imageView.image = UIImage(systemName: "doc.text.magnifyingglass")
            titleLabel.text = message ?? "暂无数据"
            
        case .loading:
            isHidden = false
            activityIndicator.startAnimating()
            imageView.image = nil
            titleLabel.text = "加载中..."
            
        case .error(let message):
            isHidden = false
            activityIndicator.stopAnimating()
            imageView.image = UIImage(systemName: "exclamationmark.triangle")
            titleLabel.text = message ?? "加载失败"
        }
    }
} 