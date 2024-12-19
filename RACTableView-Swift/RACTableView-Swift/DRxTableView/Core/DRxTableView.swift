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
import MJRefresh


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
    public var drxDataSource: DRxDataSource {
        return _drxDataSource
    }
    
    private lazy var _drxDataSource: DRxDataSource = {
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
    
    /// 是否启用下拉刷新
    public var enablePullToRefresh: Bool = false {
        didSet {
            if enablePullToRefresh {
                self.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefreshing))
            } else {
                self.mj_header = nil
            }
        }
    }
    
    /// 是否启用上拉加载更多
    public var enableLoadMore: Bool = false {
        didSet {
            if enableLoadMore {
                self.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefreshing))
            } else {
                self.mj_footer = nil
            }
        }
    }
    
    /// 空视图
    private lazy var emptyView: DRxEmptyViewProtocol = DRxEmptyView()
    
    /// 当前空视图状态
    public var emptyViewState: DRxEmptyViewState = .none {
        didSet {
            updateEmptyViewState()
        }
    }
    
    /// 是否正在加载更多
    private var isLoadingMore = false
    
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
        //去掉分割线
        separatorStyle = .none
        
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
        autoRegisterIfNeeded(for: sections)
        drxDataSource.updateData(sections)
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
    private func autoRegisterSupplementaryViewIfNeeded(_ configuration: SupplementaryConfiguration?) {
        guard let configuration = configuration else { return }
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
    
    /// 更新指定位置的Cell高度
    /// - Parameters:
    ///   - indexPath: Cell位置
    ///   - height: 新的高度
    ///   - animated: 是否用动画
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
    
    /// 开始下拉刷新
    public func beginHeaderRefreshing() {
        self.mj_header?.beginRefreshing()
    }
    
    /// 结束下拉刷新
    public func endHeaderRefreshing() {
        self.mj_header?.endRefreshing()
        UIView.animate(withDuration: 0.25) {
            self.reloadData()
        }
    }
    
    /// 开始上拉加载更多
    public func beginFooterRefreshing() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        self.mj_footer?.beginRefreshing()
    }
    
    /// 结束上拉加载更多
    public func endFooterRefreshing() {
        isLoadingMore = false
        self.mj_footer?.endRefreshing()
        UIView.animate(withDuration: 0.25) {
            self.reloadData()
        }
    }
    
    @objc open func headerRefreshing() {
        // 调用 ViewModel 中的刷新方法
        self.reloadData()
    }
    
    @objc open func footerRefreshing() {
        // 调用 ViewModel 中的加载更多方法
        self.reloadData()
    }
    
    
    @objc open func noMoreData() {
        guard let footer = self.mj_footer as? MJRefreshAutoNormalFooter else { return }
        footer.setTitle("🐳 opps~ Nothing more to load.", for: .noMoreData)
        footer.endRefreshingWithNoMoreData()
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
    
    /// 更新指定模型Cell高度
    public func updateCellHeight(for model: DRxModelProtocol, height: CGFloat, animated: Bool = true) {
        // 查找模型对应的indexPath
        for (sectionIndex, section) in drxDataSource.currentSections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.identifier == model.identifier }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                updateCellHeight(at: indexPath, height: height, animated: animated)
                break
            }
        }
    }
    
    /// 更新高度缓存
    public func updateHeightCache(for identifier: String, height: CGFloat) {
        let cacheKey = DRxHeightCache.cacheKey(
            identifier: identifier,
            width: bounds.width
        )
        heightCache.setHeight(height, for: cacheKey)
    }
    
    // 注册 cell、header 和 footer 的通用方法
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: String(describing: viewClass))
    }
    
    // 自动注册 cell 和 header/footer
    private func autoRegisterIfNeeded(for sections: [SectionModel]) {
        for section in sections {
            // 注册 cells
            for cellModel in section.cells {
                autoRegisterCellIfNeeded(cellModel.cellConfiguration)
            }
            
            // 注册 header
            if let headerConfig = section.header?.headerConfiguration {
                autoRegisterSupplementaryViewIfNeeded(headerConfig)
            }
            
            // 注册 footer
            if let footerConfig = section.footer?.footerConfiguration {
                autoRegisterSupplementaryViewIfNeeded(footerConfig)
            }
        }
    }
    
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
}

// MARK: - UITableViewDelegate
extension DRxTableView: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = model(at: indexPath) else {
            return DRxConstants.Height.defaultCell
        }

        if model.cellConfiguration.automaticHeight {
            // 自动高度模式：直接返回 automaticDimension
            return UITableView.automaticDimension
        } else {
            // 手动高度模式：使用缓存或 model 的高度
            if enableHeightCache {
                let cacheKey = DRxHeightCache.cacheKey(
                    identifier: model.identifier,
                    width: bounds.width
                )
                if let cachedHeight = heightCache.height(for: cacheKey) {
                    return cachedHeight
                }
            }
            return model.cellHeight.value
        }
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        eventRelay.accept(.willDisplayCell(cell, indexPath))

        // 只对非自动高度的 cell 进行缓存
        if enableHeightCache,
           let model = model(at: indexPath),
           !model.cellConfiguration.automaticHeight {
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
        guard section < drxDataSource.currentSections.count,
              let headerModel = drxDataSource.currentSections[section].header,
              let config = headerModel.headerConfiguration else {
            return nil
        }
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: config.identifier) as? (any UIView & DRxSupplementaryViewProtocol) {
            configureSupplementaryView(headerView, with: headerModel)
            return headerView
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < drxDataSource.currentSections.count,
              let footerModel = drxDataSource.currentSections[section].footer,
              let config = footerModel.footerConfiguration else {
            return nil
        }
        
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: config.identifier) as? (any UIView & DRxSupplementaryViewProtocol) {
            configureSupplementaryView(footerView, with: footerModel)
            return footerView
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < drxDataSource.currentSections.count,
              let headerModel = drxDataSource.currentSections[section].header,
              let config = headerModel.headerConfiguration else {
            return 0
        }
        return config.automaticHeight ? UITableView.automaticDimension : config.height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section < drxDataSource.currentSections.count,
              let footerModel = drxDataSource.currentSections[section].footer,
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
    
    // 添加预高度的处理
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = model(at: indexPath) else {
            return 44
        }
        
        if model.cellConfiguration.automaticHeight {
            if enableHeightCache {
                let cacheKey = DRxHeightCache.cacheKey(
                    identifier: model.identifier,
                    width: bounds.width
                )
                if let cachedHeight = heightCache.height(for: cacheKey) {
                    return cachedHeight
                }
            }
            return model.cellConfiguration.defaultHeight
        }
        return model.cellHeight.value
    }
}

// MARK: - Rx Extensions
extension Reactive where Base: DRxTableView {
    /// 事件列
    public var events: Observable<DRxTableViewEvent> {
        return base.eventRelay.asObservable()
    }
}

// 实现模型代理
extension DRxTableView: DRxModelDelegate {
    public func reloadCells(rows: [IndexPath], animated: Bool) {
        if animated {
            UIView.performWithoutAnimation {
                self.beginUpdates()
                if rows.count > 0 {
                    self.reloadRows(at: rows, with: .automatic)
                }
                self.endUpdates()
            }
        } else {
            self.beginUpdates()
            if rows.count > 0 {
                self.reloadRows(at: rows, with: .automatic)
            }
            self.endUpdates()
        }
    }
    
    public func modelDidUpdateHeight(_ model: DRxModelProtocol, animated: Bool) {
        // 查找模型对应的 indexPath
        for (sectionIndex, section) in drxDataSource.currentSections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.identifier == model.identifier }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)

                if model.cellConfiguration.automaticHeight {
                    // 自动高度模式：只需要触发布局新，不需要重新加载 cell
                    UIView.performWithoutAnimation {
                        self.beginUpdates()
                        self.endUpdates()
                    }
                } else {
                    // 手动高度模式：需要更新缓存并重新加载 cell
                    let cacheKey = DRxHeightCache.cacheKey(
                        identifier: model.identifier,
                        width: bounds.width
                    )
                    heightCache.setHeight(model.cellHeight.value, for: cacheKey)

                    if animated {
                        UIView.animate(withDuration: 0.25) {
                            self.beginUpdates()
                            self.reloadRows(at: [indexPath], with: .automatic)
                            self.endUpdates()
                        }
                    } else {
                        self.beginUpdates()
                        self.reloadRows(at: [indexPath], with: .automatic)
                        self.endUpdates()
                    }
                }
                break
            }
        }
    }
}


