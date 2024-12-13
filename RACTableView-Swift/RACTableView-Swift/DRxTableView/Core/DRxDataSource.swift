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
public class DRxDataSource: NSObject {
    
    // MARK: - Properties
    
    /// TableView 弱引用
    private weak var tableView: DRxTableView?
    
    /// 数据源
    private let sectionsRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    /// 数据源序列
    public var sections: Observable<[SectionModel]> {
        return sectionsRelay.asObservable()
    }
    
    /// 当前数据源值
    public var currentSections: [SectionModel] {
        return sectionsRelay.value
    }
    
    /// DisposeBag
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    public init(tableView: DRxTableView) {
        self.tableView = tableView
        super.init()
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    /// 更新数据源
    /// - Parameter sections: 新的数据源
    public func updateData(_ sections: [SectionModel]) {
        sectionsRelay.accept(sections)
    }
    
    /// 获取指定位置的模型
    /// - Parameter indexPath: 索引路径
    /// - Returns: 模型对象
    public func model(at indexPath: IndexPath) -> DRxModelProtocol? {
        guard indexPath.section < sectionsRelay.value.count,
              indexPath.row < sectionsRelay.value[indexPath.section].cells.count else {
            return nil
        }
        return sectionsRelay.value[indexPath.section].cells[indexPath.row]
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // 监听数据源变化，自动刷新TableView
        sectionsRelay
            .skip(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCell<T: DRxCellProtocol>(_ cell: T, with model: DRxModelProtocol) {
        if let model = model as? T.ModelType {
            cell.configure(with: model)
        }
    }
}

// MARK: - UITableViewDataSource
extension DRxDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsRelay.value.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsRelay.value[section].cells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model(at: indexPath) else {
            return UITableViewCell()
        }
        
        let config = model.cellConfiguration
        let identifier = config.identifier
        
        // 获取复用的Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        // 配置Cell
        if let bindableCell = cell as? any DRxCellProtocol {
            configureCell(bindableCell, with: model)
        }
        
        return cell
    }
}