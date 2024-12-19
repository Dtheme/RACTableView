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
    
    private lazy var headerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear // 设置为透明
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
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
        headerView.addSubview(headerButton) // 添加按钮到 headerView
        containerView.addSubview(nestedTableView)
        
        // 注册 SubItemCell
        nestedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubItemCell")
        
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
        
        headerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 覆盖整个 headerView
        }
        
        nestedTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 绑定按钮点击事件
        headerButton.addTarget(self, action: #selector(headerTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func headerTapped() {
        guard let model = cellModel else { return }
        eventRelay.accept(.toggleExpand(model))
    }
    
    // MARK: - DRxCellProtocol
    
    private var cellDisposeBag = DisposeBag()
    
    func configure(with model: NewsModel) {
        cellModel = model
        titleLabel.text = model.title
        
        // 更新 UI
        updateUI(with: model)
        
        // 设置数据源和代理
        nestedTableView.dataSource = self
        nestedTableView.delegate = self
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
            nestedTableView.reloadData() // 确保子 tableView 数据刷新
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 重置状态
        arrowImageView.transform = .identity  // 改为默认展开状态
        cellModel = nil
        cellDisposeBag = DisposeBag() // 重置 DisposeBag
    }
}

extension NewsNestedCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel?.subItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubItemCell", for: indexPath)
        let subItem = cellModel?.subItems[indexPath.row]
        cell.textLabel?.text = subItem?.title
        return cell
    }
} 
