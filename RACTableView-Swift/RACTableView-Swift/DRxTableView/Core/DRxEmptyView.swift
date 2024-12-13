//
//  DRxEmptyView.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit

/// 空视图状态
public enum DRxEmptyViewState {
    case empty(String?)
    case error(Error)
    case loading
    case none
}

/// 空视图协议
public protocol DRxEmptyViewProtocol: UIView {
    /// 更新状态
    func update(state: DRxEmptyViewState)
}

/// 默认空视图
open class DRxEmptyView: UIView, DRxEmptyViewProtocol {
    // MARK: - UI Elements
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
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
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(activityIndicator)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        case .empty(let message):
            imageView.image = UIImage(named: "empty_placeholder")
            titleLabel.text = message ?? "暂无数据"
            activityIndicator.stopAnimating()
            
        case .error(let error):
            imageView.image = UIImage(named: "error_placeholder")
            titleLabel.text = error.localizedDescription
            activityIndicator.stopAnimating()
            
        case .loading:
            imageView.image = nil
            titleLabel.text = "加载中..."
            activityIndicator.startAnimating()
            
        case .none:
            imageView.image = nil
            titleLabel.text = nil
            activityIndicator.stopAnimating()
        }
    }
} 