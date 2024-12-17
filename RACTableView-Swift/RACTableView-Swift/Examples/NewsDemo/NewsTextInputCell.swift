import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NewsTextInputCell: DRxBaseCell<NewsModel> {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0  // 允许多行
        label.text = "input:"
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        print("=== Creating TextView ===")
        return textView
    }()
    
    // MARK: - Properties
    
    private var cellDisposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print("\n=== NewsTextInputCell init called ===")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("NewsTextInputCell initialized with reuseIdentifier: \(String(describing: reuseIdentifier))")
        setupUI()
        print("=== End of init ===\n")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        print("\n=== setupUI called ===")
        super.setupUI()
        
        // 设置基本样式
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        // 设置 textView 属性
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        
        // 确保约束链完整
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.left.right.equalTo(contentView).inset(16)
            make.height.greaterThanOrEqualTo(30)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).offset(-12)
            make.height.greaterThanOrEqualTo(30)
        }
    }
    
    override func bindData() {
        print("\n=== bindData called ===")
        super.bindData()
        
        guard let model = self.model else { return }
        cellDisposeBag = DisposeBag()
        
        // 监听文本变化
        textView.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self,
                      let model = self.model else { return }
                
                self.titleLabel.text = text
                model.updateInputText(text)
                
                // 触发布局更新
                self.setNeedsLayout()
                

                // 通过model刷新
                if model.cellConfiguration.automaticHeight {
                    model.updateHeight(0)
                }
                // // 让系统重新计算高度
                // if let tableView = self.superview?.superview as? UITableView {
                //     UIView.performWithoutAnimation {
                //         tableView.beginUpdates()
                //         tableView.endUpdates()
                //     }
                // }
            })
            .disposed(by: cellDisposeBag)
    }
    
    override func configure(with model: NewsModel) {
        print("\n=== Configure Called ===")
        super.configure(with: model)
        
        // 只在初始配置时设置文本
        if textView.text != model.currentInputText {
            textView.text = model.currentInputText
            titleLabel.text = model.currentInputText
        }
        
        print("After configure:")
        print("Current model: \(String(describing: self.model))")
        print("TitleLabel text: \(titleLabel.text ?? "")")
        print("TextView text: \(textView.text ?? "")")
        print("=== End of Configure ===\n")
    }
    
    // 移除 prepareForReuse 中的文本清理
    override func prepareForReuse() {
        super.prepareForReuse()
        print("\n=== prepareForReuse called ===")
        cellDisposeBag = DisposeBag()
        // 不再清理文本
        // titleLabel.text = nil
        // textView.text = nil
    }
    
    // 添加 layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\n=== layoutSubviews called ===")
    }
}
