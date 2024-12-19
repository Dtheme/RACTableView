//
//  DRxDataSource.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - SectionModel
/// TableView Section 模型
public struct SectionModel {
    /// Section 唯一标识符
    public let identifier: String
    /// Section Header 模型
    public var header: DRxModelProtocol?
    /// Section Cells 模型数组
    public var cells: [DRxModelProtocol]
    /// Section Footer 模型
    public var footer: DRxModelProtocol?
    /// Section 类型标识
    public let type: String
    
    // MARK: - Init
    public init(
        identifier: String = UUID().uuidString,
        header: DRxModelProtocol? = nil,
        cells: [DRxModelProtocol] = [],
        footer: DRxModelProtocol? = nil,
        type: String = ""
    ) {
        self.identifier = identifier
        self.header = header
        self.cells = cells
        self.footer = footer
        self.type = type
    }
}

// MARK: - DRxDataSource
public class DRxDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    /// 当前数据源
    private let sectionsRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    /// 弱引用 TableView
    private weak var tableView: DRxTableView?
    
    // MARK: - Public Properties
    
    /// 当前 sections
    public var currentSections: [SectionModel] {
        return sectionsRelay.value
    }
    
    /// sections 序列
    public var sections: Observable<[SectionModel]> {
        return sectionsRelay.asObservable()
    }
    
    // MARK: - Initialization
    
    public init(tableView: DRxTableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// 更新数据源
    public func updateData(_ sections: [SectionModel]) {
        sectionsRelay.accept(sections)
        tableView?.reloadData()
        updateEmptyState()
    }
    
    /// 获取指定位置的模型
    public func model(at indexPath: IndexPath) -> DRxModelProtocol? {
        guard indexPath.section < currentSections.count,
              indexPath.row < currentSections[indexPath.section].cells.count else {
            return nil
        }
        return currentSections[indexPath.section].cells[indexPath.row]
    }
    
    // MARK: - Private Methods
    
    private func updateEmptyState() {
        let isEmpty = currentSections.allSatisfy { $0.cells.isEmpty }
        tableView?.emptyViewState = isEmpty ? .empty(message: "暂无数据") : .none
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return currentSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < currentSections.count else { return 0 }
        return currentSections[section].cells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model(at: indexPath) else {
            return UITableViewCell()
        }
        
        let identifier = model.cellConfiguration.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? (any DRxCellProtocol) {
            configureCell(cell, with: model)
        }
        
        if let tableView = tableView as? DRxTableView {
            tableView.drxDelegate?.tableView(tableView, didGetCell: cell, at: indexPath)
        }
        // 打印 cell 信息 indexPath 和 identifier 、model中的cell 类名
        print("✨cell: \(cell), indexPath: \(indexPath.section)-\(indexPath.row), cell identifier: \(identifier), cell class: \(cell.classForCoder)")
        return cell
    }
    
    private func configureCell<T: DRxCellProtocol>(_ cell: T, with model: DRxModelProtocol) {
        if let model = model as? T.ModelType {
            cell.cellModel = model
            cell.configure(with: model)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < currentSections.count,
              let headerModel = currentSections[section].header as? HeaderModel,
              let config = headerModel.headerConfiguration else {
            return nil
        }
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: config.identifier) {
            headerView.configure(with: headerModel)
            return headerView
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < currentSections.count,
              let footerModel = currentSections[section].footer as? FooterModel,
              let config = footerModel.footerConfiguration else {
            return nil
        }
        
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: config.identifier) {
            footerView.configure(with: footerModel)
            return footerView
        }
        return nil
    }
}

extension UITableViewHeaderFooterView {
    func configure(with model: Any) {
        // 在这里实现通用配置逻辑
        // 例如：设置标题、背景颜色等
    }
}
