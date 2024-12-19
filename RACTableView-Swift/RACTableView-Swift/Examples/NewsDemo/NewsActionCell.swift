import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 定义事件类型
enum NewsActionEvent {
    case delete(NewsModel)
    case addImage(NewsModel)
}

class NewsActionCell: DRxBaseCell<NewsModel> {

    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("删除图片Cell", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加图片Cell", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Properties
    
    private var cellDisposeBag = DisposeBag()
    let eventRelay = PublishRelay<NewsActionEvent>()
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(deleteButton)
        containerView.addSubview(addButton)
        
        // 设置按钮的用户交互
        deleteButton.isUserInteractionEnabled = true
        addButton.isUserInteractionEnabled = true
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo((UIScreen.main.bounds.width - 48) / 2)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.width.height.equalTo(deleteButton)
        }
    }
    
    override func bindData() {
        super.bindData()
        
        print("=== NewsActionCell bindData called ===")
        cellDisposeBag = DisposeBag()
        
        // 删除按钮事件
        // deleteButton.rx.tap
        //     .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        //     .subscribe(onNext: { [weak self] _ in
        //         print("删除按钮点击")
        //         guard let self = self,
        //               let model = self.model else {
        //             print("删除按钮点击：model is nil")
        //             return
        //         }
        //         print("发送删除事件，model identifier: \(model.identifier)")
        //         self.eventRelay.accept(.delete(model))
        //     })
        //     .disposed(by: cellDisposeBag)
        
        // 添加按钮事件
//        addButton.rx.tap
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] _ in
//                print("添加按钮点击")
//                guard let self = self,
//                      let model = self.model else {
//                    print("添加按钮点击：model is nil")
//                    return
//                }
//                print("发送添加事件，model identifier: \(model.identifier)")
//                self.eventRelay.accept(.addImage(model))
            // })
            // .disposed(by: cellDisposeBag)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func deleteButtonTapped() {
        print("删除按钮点击")
        guard let model = self.model else {
            print("添加按钮点击：model is nil")
            return
        }
        print("发送添加事件，model identifier: \(model.identifier)")
        self.eventRelay.accept(.delete(model))
    }
    
    @objc func addButtonTapped() {
        print("添加按钮点击")
        guard let model = self.model else {
            print("添加按钮点击：model is nil")
            return
        }
        print("发送添加事件，model identifier: \(model.identifier)")
        self.eventRelay.accept(.addImage(model))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("=== NewsActionCell prepareForReuse called ===")
        cellDisposeBag = DisposeBag()
    }
    
    override func configure(with model: NewsModel) {
        self.model = model
        print("\n=== NewsActionCell configure called ===")
        super.configure(with: model)
        print("Configured with model: \(model.identifier)")

        // 重新绑定事件
        bindData()
    }
} 
