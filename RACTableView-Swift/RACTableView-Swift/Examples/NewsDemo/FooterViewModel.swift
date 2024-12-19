import UIKit
import RxSwift
import RxCocoa

class FooterViewModel: DRxModelProtocol {
    var identifier: String = UUID().uuidString
    var cellConfiguration: CellConfiguration = CellConfiguration()
    var headerConfiguration: SupplementaryConfiguration? = nil
    var footerConfiguration: SupplementaryConfiguration?
    var isExpanded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var cellHeight: BehaviorRelay<CGFloat> = BehaviorRelay(value: 44)
    weak var delegate: DRxModelDelegate?

    init() {
        self.footerConfiguration = SupplementaryConfiguration(
            viewClass: CustomFooterView.self,
            identifier: CustomFooterView.reuseIdentifier,
            height: 44,
            automaticHeight: false
        )
    }
} 