//
//  DRxSupplementaryView.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/18.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
 

/// 补充视图协议
public protocol DRxSupplementaryViewProtocol: AnyObject {
    associatedtype ModelType: DRxModelProtocol
    
    /// 视图类型
    var kind: DRxSupplementaryKind { get }
    
    /// 数据模型
    var model: ModelType? { get set }
    
    /// RxSwift DisposeBag
    var disposeBag: DisposeBag { get }
    
    /// 配置视图
    func configure(with model: ModelType)
    
    /// 绑定数据
    func bindData()
}

/// 基础补充视图
open class DRxSupplementaryView<Model: DRxModelProtocol>: UITableViewHeaderFooterView, DRxSupplementaryViewProtocol {
    
    // MARK: - Properties
    
    /// 视图类型
    public let kind: DRxSupplementaryKind
    
    /// 数据模型
    public var model: Model? {
        didSet {
            if let model = model {
                configure(with: model)
            }
        }
    }
    
    /// RxSwift DisposeBag
    public let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    public init(kind: DRxSupplementaryKind, reuseIdentifier: String?) {
        self.kind = kind
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        bindData()
    }
    
    required public init?(coder: NSCoder) {
        self.kind = .header // 默认为header
        super.init(coder: coder)
        setupUI()
        bindData()
    }
    
    // MARK: - Setup
    
    /// 设置UI
    open func setupUI() {
        // 子类重写此方法来设置UI
    }
    
    // MARK: - DRxSupplementaryViewProtocol
    
    /// 配置视图
    open func configure(with model: Model) {
        self.model = model
    }
    
    /// 绑定数据
    open func bindData() {
        // 子类重写此方法来实现数据绑定
    }
}

/// Header视图
open class DRxHeaderView<Model: DRxModelProtocol>: DRxSupplementaryView<Model> {
    public init(reuseIdentifier: String? = DRxConstants.ReuseIdentifier.defaultHeader) {
        super.init(kind: .header, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// Footer视图
open class DRxFooterView<Model: DRxModelProtocol>: DRxSupplementaryView<Model> {
    public init(reuseIdentifier: String? = DRxConstants.ReuseIdentifier.defaultFooter) {
        super.init(kind: .footer, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
 

