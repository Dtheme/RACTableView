import Foundation

// MARK: - Type Aliases
public typealias DRxVoidClosure = () -> Void
public typealias DRxErrorClosure = (Error) -> Void
public typealias DRxBoolClosure = (Bool) -> Void

// MARK: - Loading State
public enum DRxLoadingState: Equatable {
    /// 无状态
    case none
    /// 加载中
    case loading
    /// 无更多数据
    case noMoreData
    /// 错误状态
    case error(Error)
    /// 空数据状态
    case empty
    
    public static func == (lhs: DRxLoadingState, rhs: DRxLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.loading, .loading),
             (.noMoreData, .noMoreData),
             (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default:
            return false
        }
    }
}

// MARK: - Empty View State
public enum DRxEmptyViewState {
    /// 无状态
    case none
    /// 空数据状态
    case empty(message: String?)
    /// 加载中状态
    case loading
    /// 错误状态
    case error(message: String?)
}

// MARK: - Supplementary Kind
public enum DRxSupplementaryKind {
    /// 头部视图
    case header
    /// 尾部视图
    case footer
} 