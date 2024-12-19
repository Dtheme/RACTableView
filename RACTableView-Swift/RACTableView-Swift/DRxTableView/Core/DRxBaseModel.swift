//
//  DRxBaseModel.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/18.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 基础数据模型
open class DRxBaseModel: DRxModelProtocol {
    
    // MARK: - Properties
    
    /// 模型唯一标识符
    public let identifier: String
    
    /// 模型关联数据
    public var data: Any?
    
    /// 是否展开
    public let isExpanded: BehaviorRelay<Bool>
    
    /// Cell高度
    public let cellHeight: BehaviorRelay<CGFloat>
    
    // MARK: - Cell Configuration
    
    /// Cell配置信息
    public var cellConfiguration: CellConfiguration {
        CellConfiguration(identifier: DRxConstants.ReuseIdentifier.defaultCell)
    }
    
    /// Header配置信息
    public var headerConfiguration: SupplementaryConfiguration? {
        return nil
    }
    
    /// Footer配置信息
    public var footerConfiguration: SupplementaryConfiguration? {
        return nil
    }
    
    // MARK: - Initialization
    
    public init(
        identifier: String = UUID().uuidString,
        data: Any? = nil,
        isExpanded: Bool = true,
        cellHeight: CGFloat = DRxConstants.Height.defaultCell
    ) {
        self.identifier = identifier
        self.data = data
        self.isExpanded = .init(value: isExpanded)
        self.cellHeight = .init(value: cellHeight)
    }
    
    // MARK: - Helper Methods
    
    /// 切换展开/折叠状态
    public func toggleExpanded() {
        isExpanded.accept(!isExpanded.value)
    }
    
    /// 更新Cell高度并触发刷新
    /// - Parameters:
    ///   - height: 新的高度
    ///   - animated: 是否使用动画
    public func updateHeight(_ height: CGFloat, animated: Bool = true) {
        cellHeight.accept(height)
        
        // 通知更新（需要添加代理方法）
        delegate?.modelDidUpdateHeight(self, animated: animated)
    }
    
    /// 模型代理
    public weak var delegate: DRxModelDelegate?
}

// MARK: - Equatable
extension DRxBaseModel: Equatable {
    public static func == (lhs: DRxBaseModel, rhs: DRxBaseModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: - Hashable
extension DRxBaseModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - Header and Footer Models
class HeaderModel: DRxBaseModel {
    // 可以在这里重写 headerConfiguration
}

class FooterModel: DRxBaseModel {
    // 可以在这里重写 footerConfiguration
}

 
