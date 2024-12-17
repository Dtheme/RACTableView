import UIKit
import RxSwift
import RxCocoa

// MARK: - 模型配置协议
public protocol DRxModelProtocol: AnyObject {
    /// 模型唯一标识符
    var identifier: String { get }
    
    /// Cell 配置信息
    var cellConfiguration: CellConfiguration { get }
    
    /// Header 配置信息
    var headerConfiguration: SupplementaryConfiguration? { get }
    
    /// Footer 配置信息
    var footerConfiguration: SupplementaryConfiguration? { get }
    
    /// 是否展开（用于折叠功能）
    var isExpanded: BehaviorRelay<Bool> { get }
    
    /// Cell高度（支持动态高度）
    var cellHeight: BehaviorRelay<CGFloat> { get }
    
    /// 更新Cell高度
    /// - Parameters:
    ///   - height: 新的高度
    ///   - animated: 是否使用动画
    func updateHeight(_ height: CGFloat, animated: Bool)
    
    /// 模型代理
    var delegate: DRxModelDelegate? { get set }
}

// MARK: - Cell 配置协议
public protocol DRxCellProtocol: AnyObject {
    associatedtype ModelType: DRxModelProtocol
    
    /// Cell的数据模型
    var cellModel: ModelType? { get set }
    
    /// 用于存储RxSwift订阅的DisposeBag
    var disposeBag: DisposeBag { get }
    
    /// 配置Cell
    func configure(with model: ModelType)
    
    /// 绑定数据
    func bindData()
}

// MARK: - Cell 配置信息
public struct CellConfiguration {
    /// Cell 类型
    public let cellClass: AnyClass?
    /// Cell Nib
    public let cellNib: UINib?
    /// Cell 重用标识符
    public let identifier: String
    /// 是否启用自动计算高度
    public let automaticHeight: Bool
    /// 默认高度
    public let defaultHeight: CGFloat
    
    public init(
        cellClass: AnyClass? = nil,
        cellNib: UINib? = nil,
        identifier: String? = nil,
        automaticHeight: Bool = false,
        defaultHeight: CGFloat = DRxConstants.Height.defaultCell
    ) {
        self.cellClass = cellClass
        self.cellNib = cellNib
        self.identifier = identifier ?? UUID().uuidString
        self.automaticHeight = automaticHeight
        self.defaultHeight = defaultHeight
    }
    public init(
        cellClass: AnyClass? = nil,
        cellNib: UINib? = nil,
        identifier: String? = nil,
        automaticHeight: Bool = false
    ) {
        self.cellClass = cellClass
        self.cellNib = cellNib
        self.identifier = identifier ?? UUID().uuidString
        self.automaticHeight = automaticHeight
        self.defaultHeight = 44
    }
}

// MARK: - Supplementary 配置信息
public struct SupplementaryConfiguration {
    /// 视图类型
    public let viewClass: AnyClass?
    /// 视图 Nib
    public let viewNib: UINib?
    /// 重用标识符
    public let identifier: String
    /// 视图高度
    public let height: CGFloat
    /// 是否启用自动计算高度
    public let automaticHeight: Bool
    
    public init(
        viewClass: AnyClass? = nil,
        viewNib: UINib? = nil,
        identifier: String? = nil,
        height: CGFloat = DRxConstants.Height.defaultHeader,
        automaticHeight: Bool = false
    ) {
        self.viewClass = viewClass
        self.viewNib = viewNib
        self.identifier = identifier ?? UUID().uuidString
        self.height = height
        self.automaticHeight = automaticHeight
    }
}

// MARK: - TableView代理协议
public protocol DRxTableViewDelegate: AnyObject {
    /// Cell实例回调
    func tableView(_ tableView: UITableView, didGetCell cell: UITableViewCell, at indexPath: IndexPath)

    /// Header实例回调
    func tableView(_ tableView: UITableView, didGetHeaderView view: UIView, in section: Int)

    /// Footer实例回调
    func tableView(_ tableView: UITableView, didGetFooterView view: UIView, in section: Int)
}

// MARK: - 模型代理协议
public protocol DRxModelDelegate: AnyObject {
    /// 模型高度更新回调
    func modelDidUpdateHeight(_ model: DRxModelProtocol, animated: Bool)
    func reloadCells(rows: [IndexPath],animated: Bool)
//    public func reloadCells(rows: [IndexPath] = [],animated: Bool) {
}

// MARK: - 默认实现
public extension DRxModelProtocol {
    var identifier: String { String(describing: type(of: self)) }
    var isExpanded: BehaviorRelay<Bool> { .init(value: true) }
    var cellHeight: BehaviorRelay<CGFloat> { .init(value: DRxConstants.Height.defaultCell) }
    
    var headerConfiguration: SupplementaryConfiguration? { nil }
    var footerConfiguration: SupplementaryConfiguration? { nil }
    
    func updateHeight(_ height: CGFloat, animated: Bool = true) {
        cellHeight.accept(height)
        delegate?.modelDidUpdateHeight(self, animated: animated)
    }
    func updateTableV(rows: [IndexPath] = [], animated: Bool = true) {
        delegate?.reloadCells(rows: rows, animated: true)

    }
}

public extension DRxCellProtocol {
    var disposeBag: DisposeBag { DisposeBag() }
    
    func bindData() {
        // 默认为空
    }
}
