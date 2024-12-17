import UIKit
import RxSwift
import RxCocoa

open class DRxBaseCell<Model: DRxModelProtocol>: UITableViewCell {
    // MARK: - Properties
    /// 数据模型
    public var model: Model?
    
    /// RxSwift DisposeBag
    public let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    open func setupUI() {
        // 子类重写此方法来设置UI
    }
    
    // MARK: - DRxCellProtocol
    open func configure(with model: Model) {
        print("=== DRxBaseCell configure called ===")
        self.model = model
        bindData()
        print("=== DRxBaseCell configure end ===")
    }
    
    open func bindData() {
        print("=== DRxBaseCell bindData called ===")
        // 子类重写此方法来实现数据绑定
        print("=== DRxBaseCell bindData end ===")
    }
    
    /// 更新Cell高度
    /// - Parameters:
    ///   - height: 新的高度
    ///   - animated: 是否使用动画
    public func updateHeight(_ height: CGFloat, animated: Bool = true) {
        model?.updateHeight(height, animated: animated)
    }
    
    /// 自动计算并更新高度
    /// - Parameter animated: 是否使用动画
    public func updateAutomaticHeight(animated: Bool = true) {
        setNeedsLayout()
        layoutIfNeeded()
        
        let height = contentView.systemLayoutSizeFitting(
            CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        updateHeight(height, animated: animated)
    }
}