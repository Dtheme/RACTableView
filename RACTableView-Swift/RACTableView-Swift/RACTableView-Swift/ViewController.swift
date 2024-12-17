import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // Demo 按钮
    private lazy var demoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DRxTableView Demo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(demoButton)
        
        NSLayoutConstraint.activate([
            demoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            demoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            demoButton.widthAnchor.constraint(equalToConstant: 200),
            demoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func bindActions() {
        demoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let newsVC = NewsListViewController()
                let nav = UINavigationController(rootViewController: newsVC)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            })
            .disposed(by: disposeBag)
    }
} 
