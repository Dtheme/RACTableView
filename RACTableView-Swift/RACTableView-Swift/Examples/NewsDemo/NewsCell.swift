import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class NewsCell: UITableViewCell, DRxCellProtocol {
    
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
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
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
        containerView.addSubview(newsImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(dateLabel)
        
        // 设置约束
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        newsImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView)
            make.left.equalTo(newsImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(newsImageView)
        }
    }
    
    // MARK: - DRxCellProtocol
    
    func configure(with model: NewsModel) {
        titleLabel.text = model.title
        contentLabel.text = model.content
        
        // 设置图片
        if let url = URL(string: model.imageURL) {
            newsImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.2)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 160, height: 160))),
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