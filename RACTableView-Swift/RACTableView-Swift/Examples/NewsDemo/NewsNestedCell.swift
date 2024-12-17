import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 定义展开/收起事件
enum NewsNestedCellEvent {
    case toggleExpand(NewsModel)
}

class NewsNestedCell: UITableViewCell, DRxCellProtocol {
    
    // MARK: - Properties
    
    /// 事件发送器
    let eventRelay = PublishRelay<NewsNestedCellEvent>()
    
    internal var cellModel: NewsModel?

    /// 嵌套的 TableView
    private lazy var nestedTableView: DRxTableView = {
        let tableView = DRxTableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.contentInset = .zero
        return tableView
    }()
    
    // MARK: - UI Components
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 添加视图
        contentView.addSubview(containerView)
        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(arrowImageView)
        containerView.addSubview(nestedTableView)
        
        // 设置约束
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        nestedTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 添加点击手势
        setupGestures()
    }
    
    private func setupGestures() {
        // 移除旧的手势识别器
        headerView.gestureRecognizers?.forEach { headerView.removeGestureRecognizer($0) }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        tapGesture.cancelsTouchesInView = false
        headerView.addGestureRecognizer(tapGesture)
        headerView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func headerTapped() {
        guard let model = cellModel else { return }
        eventRelay.accept(.toggleExpand(model))
    }
    
    // MARK: - DRxCellProtocol
    
    func configure(with model: NewsModel) {
        cellModel = model
        titleLabel.text = model.title
        
        // 将子项目转换为 NewsSubModel
        let subModels = model.subItems.map { item in
            let subModel = NewsSubModel(title: item.title, subtitle: item.subtitle)
            subModel.delegate = model.delegate
            return subModel
        }
        
        // 创建 section
        let section = SectionModel(identifier: "subItems", cells: subModels)
        
        // 更新嵌套列表数据
        nestedTableView.updateData([section])
        
        // 更新 UI
        updateUI(with: model)
    }
    
    private func updateUI(with model: NewsModel) {
        // 根据当前状态更新 UI
        let isExpanded = model.isExpanded.value
        
        // 更新箭头方向
        arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: -.pi/2)
        
        // 更新嵌套列表显示状态
        nestedTableView.isHidden = !isExpanded
        
        // 如果是展开状态，确保布局正确
        if isExpanded {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 重置状态
        arrowImageView.transform = .identity  // 改为默认展开状态
        cellModel = nil
    }
} 
