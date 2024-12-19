import UIKit
import SnapKit
import RxSwift

class CustomHeaderView: UITableViewHeaderFooterView, DRxSupplementaryViewProtocol {
    typealias ModelType = HeaderViewModel
    
    static let reuseIdentifier = "CustomHeaderView"
    
    var kind: DRxSupplementaryKind = .header
    var model: HeaderViewModel?
    var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    func configure(with model: HeaderViewModel) {
        self.model = model
        titleLabel.text = model.title
    }
    
    func bindData() {
        // 绑定数据逻辑
    }
} 
