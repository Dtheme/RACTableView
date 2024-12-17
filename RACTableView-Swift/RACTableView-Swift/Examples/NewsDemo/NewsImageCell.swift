import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class NewsImageCell: UITableViewCell, DRxCellProtocol {
    
    // MARK: - Properties
    
    var cellModel: NewsModel? {
        didSet {
            if let model = cellModel {
                configure(with: model)
            }
        }
    }
    
    let disposeBag = DisposeBag()
    
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
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        layer.locations = [0, 1]
        return layer
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = newsImageView.bounds
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 添加视图
        contentView.addSubview(containerView)
        containerView.addSubview(newsImageView)
        newsImageView.layer.addSublayer(gradientLayer)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        
        // 设置约束
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        newsImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalTo(dateLabel.snp.top).offset(-8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - DRxCellProtocol
    
    func configure(with model: NewsModel) {
        titleLabel.text = model.title
        
        // 设置图片
        if let url = URL(string: model.imageURL) {
            newsImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.2)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            )
        }
        
        // 格式化日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = dateFormatter.string(from: model.date)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.kf.cancelDownloadTask()
        newsImageView.image = nil
    }
} 