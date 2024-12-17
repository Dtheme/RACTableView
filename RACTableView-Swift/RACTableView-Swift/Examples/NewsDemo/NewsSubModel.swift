import Foundation
import RxSwift
import RxCocoa

class NewsSubModel: DRxModelProtocol {
    // MARK: - Properties
    
    let identifier: String
    let title: String
    let subtitle: String
    let cellHeight: BehaviorRelay<CGFloat>
    let isExpanded: BehaviorRelay<Bool>
    weak var delegate: DRxModelDelegate?
    
    var cellConfiguration: CellConfiguration {
        return CellConfiguration(
            cellClass: NewsSubCell.self,
            identifier: String(describing: NewsSubCell.self),
            automaticHeight: false,
            defaultHeight: 60
        )
    }
    
    var headerConfiguration: SupplementaryConfiguration? { nil }
    var footerConfiguration: SupplementaryConfiguration? { nil }
    
    // MARK: - Initialization
    
    init(title: String, subtitle: String) {
        self.identifier = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.cellHeight = BehaviorRelay(value: 60)
        self.isExpanded = BehaviorRelay(value: false)
    }
    
    // MARK: - DRxModelProtocol
    
    func updateHeight(_ height: CGFloat, animated: Bool) {
        cellHeight.accept(height)
        delegate?.modelDidUpdateHeight(self, animated: animated)
    }
} 
