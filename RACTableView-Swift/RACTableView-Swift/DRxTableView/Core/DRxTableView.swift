//
//  DRxTableView.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// DRxTableView 事件类型
public enum DRxTableViewEvent {
    case didScroll(UIScrollView)
    case willDisplayCell(UITableViewCell, IndexPath)
    case didEndDisplayingCell(UITableViewCell, IndexPath)
    case didSelectRow(IndexPath)
}

open class DRxTableView: UITableView {
    
    // MARK: - Properties
    
    /// 事件发送器
    public let eventRelay = PublishRelay<DRxTableViewEvent>()
    
    /// 数据源
    public private(set) lazy var drxDataSource: DRxDataSource = {
        let dataSource = DRxDataSource(tableView: self)
        self.dataSource = dataSource
        return dataSource
    }()
    
    /// RxSwift DisposeBag
    public let disposeBag = DisposeBag()
    
    /// 代理
    public weak var drxDelegate: DRxTableViewDelegate?
    
    /// 高度缓存管理器
    private lazy var heightCache = DRxHeightCache()
    
    /// 是否启用高度缓存
    public var enableHeightCache: Bool = true
    
    /// 已注册的Cell类型
    private var registeredCellTypes: Set<String> = []
    
    /// 已注册的Header/Footer类型
    private var registeredSupplementaryTypes: Set<String> = []
    
    /// 默认动画配置
    public var defaultAnimation: DRxAnimationConfig = .default
    
    /// 自定义刷新控件
    private lazy var drxRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    
    /// 是否正在加载更多
    private var isLoadingMore = false
    
    /// 刷新回调
    public var onRefresh: (() -> Void)?
    
    /// 加载更多回调
    public var onLoadMore: (() -> Void)?
    
    /// 是否启用下拉刷新
    public var enablePullToRefresh: Bool = false {
        didSet {
            if enablePullToRefresh {
                self.refreshControl = drxRefreshControl
            } else {
                self.refreshControl = nil
            }
        }
    }
    
    /// 是否启用上拉加载更多
    public var enableLoadMore: Bool = false
    
    /// 空视图
    private lazy var emptyView: DRxEmptyViewProtocol = DRxEmptyView()
    
    /// 当前空视图状态
    public var emptyViewState: DRxEmptyViewState = .none {
        didSet {
            updateEmptyViewState()
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        delegate = self
        estimatedRowHeight = 44
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        
        setupBindings()
    }
    
    private func setupBindings() {
        // 监听选中事件
        rx.itemSelected
            .map { DRxTableViewEvent.didSelectRow($0) }
            .bind(to: eventRelay)
            .disposed(by: disposeBag)
        
        // 监听滚动事件
        rx.didScroll
            .map { [weak self] _ in 
                DRxTableViewEvent.didScroll(self ?? UIScrollView())
            }
            .bind(to: eventRelay)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    /// 注册Cell
    public func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    /// 注册Header/Footer视图
    public func register<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: String(describing: viewType))
    }
    
    /// 更新数据源
    public func updateData(_ sections: [SectionModel]) {
        updateData(sections, animation: .none)
    }
    
    /// 获取指定位置的模型
    public func model(at indexPath: IndexPath) -> DRxModelProtocol? {
        return drxDataSource.model(at: indexPath)
    }
    
    /// 自动注册Cell
    /// - Parameter configuration: Cell配置信息
    private func autoRegisterCellIfNeeded(_ configuration: CellConfiguration) {
        let identifier = configuration.identifier
        guard !registeredCellTypes.contains(identifier) else { return }
        
        if let cellClass = configuration.cellClass {
            register(cellClass, forCellReuseIdentifier: identifier)
        } else if let nib = configuration.cellNib {
            register(nib, forCellReuseIdentifier: identifier)
        }
        
        registeredCellTypes.insert(identifier)
    }
    
    /// 自动注册Header/Footer视图
    /// - Parameter configuration: 补充视图配置信息
    private func autoRegisterSupplementaryViewIfNeeded(_ configuration: SupplementaryConfiguration) {
        let identifier = configuration.identifier
        guard !registeredSupplementaryTypes.contains(identifier) else { return }
        
        if let viewClass = configuration.viewClass {
            register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
        } else if let nib = configuration.viewNib {
            register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
        
        registeredSupplementaryTypes.insert(identifier)
    }
    
    /// 更新数据源时自动注册所需的视图类型
    private func autoRegisterTypesIfNeeded(_ sections: [SectionModel]) {
        for section in sections {
            // 注册Header
            if let header = section.header,
               let config = header.headerConfiguration {
                autoRegisterSupplementaryViewIfNeeded(config)
            }
            
            // 注册Cells
            for cellModel in section.cells {
                autoRegisterCellIfNeeded(cellModel.cellConfiguration)
            }
            
            // 注册Footer
            if let footer = section.footer,
               let config = footer.footerConfiguration {
                autoRegisterSupplementaryViewIfNeeded(config)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private struct TableViewChanges {
        var deletedSections: [Int] = []
        var insertedSections: [Int] = []
        var deletedRows: [IndexPath] = []
        var insertedRows: [IndexPath] = []
        var updatedRows: [IndexPath] = []
    }
    
    private func calculateChanges(from oldSections: [SectionModel], to newSections: [SectionModel]) -> TableViewChanges {
        var changes = TableViewChanges()
        
        // 计算Section变化
        let oldSectionIds = Set(oldSections.map { $0.identifier })
        let newSectionIds = Set(newSections.map { $0.identifier })
        
        changes.deletedSections = oldSections.enumerated()
            .filter { !newSectionIds.contains($0.element.identifier) }
            .map { $0.offset }
        
        changes.insertedSections = newSections.enumerated()
            .filter { !oldSectionIds.contains($0.element.identifier) }
            .map { $0.offset }
        
        // 计算Row变化
        for (sectionIndex, (oldSection, newSection)) in zip(oldSections, newSections).enumerated() {
            let oldCellIds = Set(oldSection.cells.map { $0.identifier })
            let newCellIds = Set(newSection.cells.map { $0.identifier })
            
            // 删除的行
            for (rowIndex, cell) in oldSection.cells.enumerated() {
                if !newCellIds.contains(cell.identifier) {
                    changes.deletedRows.append(IndexPath(row: rowIndex, section: sectionIndex))
                }
            }
            
            // 插入的行
            for (rowIndex, cell) in newSection.cells.enumerated() {
                if !oldCellIds.contains(cell.identifier) {
                    changes.insertedRows.append(IndexPath(row: rowIndex, section: sectionIndex))
                }
            }
            
            // 更新的行
            for (rowIndex, cell) in newSection.cells.enumerated() {
                if oldCellIds.contains(cell.identifier) {
                    changes.updatedRows.append(IndexPath(row: rowIndex, section: sectionIndex))
                }
            }
        }
        
        return changes
    }
    
    public func updateData(_ sections: [SectionModel], animation: DRxAnimationConfig) {
        autoRegisterTypesIfNeeded(sections)
        
        // 如果是无动画，直接更新
        guard animation.animation != .none else {
            drxDataSource.updateData(sections)
            return
        }
        
        // 计算差异并应用动画
        let oldSections = drxDataSource.currentSections
        let changes = calculateChanges(from: oldSections, to: sections)
        
        // 应用动画
        UIView.animate(
            withDuration: animation.duration,
            delay: animation.delay,
            options: animation.options
        ) {
            self.beginUpdates()
            
            // 更新数据源
            self.drxDataSource.updateData(sections)
            
            // 应用Section变化
            if !changes.deletedSections.isEmpty {
                self.deleteSections(IndexSet(changes.deletedSections), with: animation.animation)
            }
            if !changes.insertedSections.isEmpty {
                self.insertSections(IndexSet(changes.insertedSections), with: animation.animation)
            }
            
            // 应用Row变化
            if !changes.deletedRows.isEmpty {
                self.deleteRows(at: changes.deletedRows, with: animation.animation)
            }
            if !changes.insertedRows.isEmpty {
                self.insertRows(at: changes.insertedRows, with: animation.animation)
            }
            if !changes.updatedRows.isEmpty {
                self.reloadRows(at: changes.updatedRows, with: animation.animation)
            }
            
            self.endUpdates()
        }
    }
    
    /// 更新指定位置的Cell高度
    /// - Parameters:
    ///   - indexPath: Cell位置
    ///   - height: 新的高度
    ///   - animated: 是否使用动画
    public func updateCellHeight(at indexPath: IndexPath, height: CGFloat, animated: Bool = true) {
        guard let model = model(at: indexPath) else { return }
        
        // 更新缓存
        if enableHeightCache {
            let cacheKey = DRxHeightCache.cacheKey(
                identifier: model.identifier,
                width: bounds.width
            )
            heightCache.setHeight(height, for: cacheKey)
        }
        
        // 更新模型
        model.cellHeight.accept(height)
        
        // 刷新UI
        if animated {
            UIView.animate(
                withDuration: DRxConstants.Animation.defaultDuration,
                delay: 0,
                options: .curveEaseInOut
            ) {
                self.beginUpdates()
                self.endUpdates()
            }
        } else {
            self.beginUpdates()
            self.endUpdates()
        }
    }
    
    // MARK: - Refresh & LoadMore
    
    @objc private func handleRefresh() {
        onRefresh?()
    }
    
    /// 结束刷新
    public func endRefreshing() {
        drxRefreshControl.endRefreshing()
    }
    
    /// 结束加载更多
    public func endLoadingMore() {
        isLoadingMore = false
    }
    
    // 在 UIScrollViewDelegate 中添加
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard enableLoadMore && !isLoadingMore else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - DRxConstants.Performance.preloadThreshold {
            isLoadingMore = true
            onLoadMore?()
        }
    }
    
    private func updateEmptyViewState() {
        switch emptyViewState {
        case .none:
            emptyView.removeFromSuperview()
            
        default:
            if emptyView.superview == nil {
                addSubview(emptyView)
                emptyView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    emptyView.topAnchor.constraint(equalTo: topAnchor),
                    emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
            emptyView.update(state: emptyViewState)
        }
    }
    
    /// 设置自定义空视图
    public func setEmptyView(_ view: DRxEmptyViewProtocol) {
        emptyView = view
        updateEmptyViewState()
    }
}

// MARK: - UITableViewDelegate
extension DRxTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = model(at: indexPath) else {
            return DRxConstants.Height.defaultCell
        }
        
        if model.cellConfiguration.automaticHeight {
            if enableHeightCache {
                // 尝试从缓存获取高度
                let cacheKey = DRxHeightCache.cacheKey(
                    identifier: model.identifier,
                    width: bounds.width
                )
                if let cachedHeight = heightCache.height(for: cacheKey) {
                    return cachedHeight
                }
            }
            return UITableView.automaticDimension
        }
        
        return model.cellHeight.value
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        eventRelay.accept(.willDisplayCell(cell, indexPath))
        
        // 缓存自动计算的高度
        if enableHeightCache,
           let model = model(at: indexPath),
           model.cellConfiguration.automaticHeight {
            let cacheKey = DRxHeightCache.cacheKey(
                identifier: model.identifier,
                width: bounds.width
            )
            heightCache.setHeight(cell.bounds.height, for: cacheKey)
        }
        
        if let cell = cell as? UITableViewCell {
            drxDelegate?.tableView(tableView, didGetCell: cell, at: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        eventRelay.accept(.didEndDisplayingCell(cell, indexPath))
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventRelay.accept(.didSelectRow(indexPath))
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = drxDataSource.currentSections[section].header,
              let config = headerModel.headerConfiguration else {
            return nil
        }
        
        let identifier = config.identifier
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        
        if let headerView = headerView as? (any DRxSupplementaryViewProtocol) {
            if let model = headerModel as? any DRxModelProtocol {
                configureSupplementaryView(headerView, with: model)
            }
            if let view = headerView as? UIView {
                drxDelegate?.tableView(tableView, didGetHeaderView: view, in: section)
            }
        }
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerModel = drxDataSource.currentSections[section].footer,
              let config = footerModel.footerConfiguration else {
            return nil
        }
        
        let identifier = config.identifier
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        
        if let footerView = footerView as? (any DRxSupplementaryViewProtocol) {
            if let model = footerModel as? any DRxModelProtocol {
                configureSupplementaryView(footerView, with: model)
            }
            if let view = footerView as? UIView {
                drxDelegate?.tableView(tableView, didGetFooterView: view, in: section)
            }
        }
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerModel = drxDataSource.currentSections[section].header,
              let config = headerModel.headerConfiguration else {
            return 0
        }
        return config.automaticHeight ? UITableView.automaticDimension : config.height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerModel = drxDataSource.currentSections[section].footer,
              let config = footerModel.footerConfiguration else {
            return 0
        }
        return config.automaticHeight ? UITableView.automaticDimension : config.height
    }
    
    private func configureSupplementaryView<T: DRxSupplementaryViewProtocol>(_ view: T, with model: DRxModelProtocol) {
        if let model = model as? T.ModelType {
            view.configure(with: model)
        }
    }
}

// MARK: - Rx Extensions
extension Reactive where Base: DRxTableView {
    /// 事件序列
    public var events: Observable<DRxTableViewEvent> {
        return base.eventRelay.asObservable()
    }
    
    /// 数据源序列
    public var sections: Observable<[SectionModel]> {
        return base.drxDataSource.sections
    }
}

// 实现模型代理
extension DRxTableView: DRxModelDelegate {
    public func modelDidUpdateHeight(_ model: DRxModelProtocol, animated: Bool) {
        // 查找模型对应的indexPath
        for (sectionIndex, section) in drxDataSource.currentSections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.identifier == model.identifier }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                updateCellHeight(at: indexPath, height: model.cellHeight.value, animated: animated)
                break
            }
        }
    }
}