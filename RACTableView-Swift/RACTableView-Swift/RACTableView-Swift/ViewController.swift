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


        // 获取当前导航栏的 appearance
        let appearance = UINavigationBarAppearance()

        // 设置背景颜色为纯色 (例如白色)
        appearance.backgroundColor = .white
        // 禁用透明度渐变效果
        appearance.configureWithOpaqueBackground()
        // 设置导航栏的前景颜色
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        // 去掉底部的黑线
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        // 应用外观设置到全局导航栏
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
