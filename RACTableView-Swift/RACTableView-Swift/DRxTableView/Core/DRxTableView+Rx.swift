import UIKit
import RxSwift
import RxCocoa

// MARK: - Rx Extensions
extension Reactive where Base: DRxTableView {
    /// 加载状态
    public var loadingState: Binder<DRxLoadingState> {
        return Binder(base) { tableView, state in
            switch state {
            case .loading:
                tableView.emptyViewState = .loading
            case .noMoreData:
                // 处理无更多数据状态
                break
            case .error(let error):
                tableView.emptyViewState = .error(message: error.localizedDescription)
            case .empty:
                tableView.emptyViewState = .empty(message: "暂无数据")
            case .none:
                tableView.emptyViewState = .none
            }
        }
    }
    
    /// 数据源
    public var sections: Binder<[SectionModel]> {
        return Binder(base) { tableView, sections in
            tableView.updateData(sections)
        }
    }
    
    /// 下拉刷新事件
    public var headerRefreshing: ControlEvent<Void> {
        let source = base.rx.methodInvoked(#selector(Base.headerRefreshing))
            .map { _ in () }
        return ControlEvent(events: source)
    }
    
    /// 上拉加载更多事件
    public var footerRefreshing: ControlEvent<Void> {
        let source = base.rx.methodInvoked(#selector(Base.footerRefreshing))
            .map { _ in () }
        return ControlEvent(events: source)
    }
} 