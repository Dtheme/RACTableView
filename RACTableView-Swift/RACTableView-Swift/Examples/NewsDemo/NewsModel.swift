import Foundation
import RxSwift
import RxCocoa

// MARK: - News Sub Item
struct NewsSubItem {
    let title: String
    let subtitle: String
}

// MARK: - News Cell Type
enum NewsCellType {
    case normal
    case image
    case nested
    case textInput
    case action
}

class NewsModel: DRxModelProtocol {
    
    // MARK: - Properties
    
    /// 标识符
    let identifier: String
    
    /// 标题
    let title: String
    
    /// 内容
    let content: String
    
    /// 图片URL
    let imageURL: String
    
    /// 发布时间
    let date: Date
    
    /// Cell类型
    let cellType: NewsCellType
    
    /// 子项目列表
    let subItems: [NewsSubItem]
    
    /// Cell配置
    var cellConfiguration: CellConfiguration {
        switch cellType {
        case .normal:
            return CellConfiguration(
                cellClass: NewsCell.self,
                identifier: NewsCell.defaultReuseIdentifier,
                automaticHeight: false,
                defaultHeight: 120
            )
        case .image:
            return CellConfiguration(
                cellClass: NewsImageCell.self,
                identifier: NewsImageCell.defaultReuseIdentifier,
                automaticHeight: false,
                defaultHeight: 216 // 200 + 16(上下间距)
            )
        case .nested:
            return CellConfiguration(
                cellClass: NewsNestedCell.self,
                identifier: NewsNestedCell.defaultReuseIdentifier,
                automaticHeight: false,
                defaultHeight: calculateNestedHeight(isExpanded: isExpanded.value)
            )
        case .textInput:
            return CellConfiguration(
                cellClass: NewsTextInputCell.self as AnyClass,
                identifier: NewsTextInputCell.defaultReuseIdentifier,
                automaticHeight: true,
                defaultHeight: 44
            )
        case .action:
            return CellConfiguration(
                cellClass: NewsActionCell.self as AnyClass,
                identifier: NewsActionCell.defaultReuseIdentifier,
                automaticHeight: false,
                defaultHeight: 68
            )
        }
    }
    
    /// Cell高度
    let cellHeight: BehaviorRelay<CGFloat>
    
    /// 是否展开
    let isExpanded: BehaviorRelay<Bool>
    
    /// Header配置
    var headerConfiguration: SupplementaryConfiguration? { nil }
    
    /// Footer配置
    var footerConfiguration: SupplementaryConfiguration? { nil }
    
    /// 代理
    weak var delegate: DRxModelDelegate?
    
    /// 输入的文本（用于 textInput 类型）
    private let inputText = BehaviorRelay<String>(value: "")
    
    /// 输入文本序列
    var inputTextObservable: Observable<String> {
        return inputText.asObservable()
    }
    
    /// 更新输入文本
    func updateInputText(_ text: String) {
        inputText.accept(text)
    }
    
    /// 获取当前输入文本
    var currentInputText: String {
        return inputText.value
    }
    
    // MARK: - Initialization
    
    init(title: String, content: String, imageURL: String, date: Date, cellType: NewsCellType = .normal, subItems: [NewsSubItem] = [], isExpanded: Bool = false) {
        self.identifier = UUID().uuidString
        self.title = title
        self.content = content
        self.imageURL = imageURL
        self.date = date
        self.cellType = cellType
        self.subItems = subItems
        self.isExpanded = BehaviorRelay(value: isExpanded)

        // 初始化高度
        let initialHeight: CGFloat
        switch cellType {
        case .normal:
            initialHeight = 120
        case .image:
            initialHeight = 216
        case .nested:
            // 直接计算嵌套高度，避免使用self
            initialHeight = isExpanded ?
                (44 + CGFloat(subItems.count) * 60 + 16) : // header高度 + 子项目高度 + 间距
                64 // 起状态固定高度
        case .textInput:
            initialHeight = 0///30
        case .action:
            initialHeight = 68
        }
        self.cellHeight = BehaviorRelay(value: initialHeight)
    }
    
    // MARK: - DRxModelProtocol
    
    func updateHeight(_ height: CGFloat, animated: Bool) {
        if height != 0 {
            cellHeight.accept(height)
        }
        delegate?.modelDidUpdateHeight(self, animated: animated)
    }
    
    // MARK: - Helper Methods
    
    /// 计算嵌套列表的高度
    func calculateNestedHeight(isExpanded: Bool) -> CGFloat {
        if isExpanded {
            return 44 + CGFloat(subItems.count) * 60 + 16 // header高度 + 子项目高度 + 间距
        } else {
            return 64 // 收起状态固定高度
        }
    }
} 
