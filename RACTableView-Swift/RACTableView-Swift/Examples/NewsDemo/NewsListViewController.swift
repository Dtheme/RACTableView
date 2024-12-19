import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = NewsListViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置自定义手势返回
        setupCustomDismissGesture()
        
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "科技新闻"
        view.backgroundColor = .systemBackground
        
        // 设置 TableView
        viewModel.tableView.drxDelegate = viewModel
        viewModel.tableView.enablePullToRefresh = true
        viewModel.tableView.enableLoadMore = true
        
        view.addSubview(viewModel.tableView)
        viewModel.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        // 绑定数据源
        viewModel.sectionsOutput
            .bind(to: viewModel.tableView.rx.sections)
            .disposed(by: disposeBag)
        
        // 绑定加载状态
        viewModel.loadingStateOutput
            .bind(to: viewModel.tableView.rx.loadingState)
            .disposed(by: disposeBag)
    }
    
    private func setupCustomDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NewsListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只有在导航堆栈中有多个视图控制器时才允许手势返回
        return navigationController?.viewControllers.count ?? 0 > 1
    }
} 