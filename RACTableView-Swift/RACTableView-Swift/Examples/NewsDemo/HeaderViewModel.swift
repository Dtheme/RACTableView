import UIKit
import RxSwift
import RxCocoa

class HeaderViewModel: DRxModelProtocol {
    var identifier: String = UUID().uuidString
    var cellConfiguration: CellConfiguration = CellConfiguration()
    var headerConfiguration: SupplementaryConfiguration?
    var footerConfiguration: SupplementaryConfiguration? = nil
    var isExpanded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var cellHeight: BehaviorRelay<CGFloat> = BehaviorRelay(value: 44)
    weak var delegate: DRxModelDelegate?

    var title: String

    init(title: String) {
        self.title = title
        self.headerConfiguration = SupplementaryConfiguration(
            viewClass: CustomHeaderView.self,
            identifier: CustomHeaderView.reuseIdentifier,
            height: 44,
            automaticHeight: false
        )
    }
} 