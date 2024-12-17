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
} 