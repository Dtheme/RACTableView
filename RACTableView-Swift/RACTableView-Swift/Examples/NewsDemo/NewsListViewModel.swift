import Foundation
import RxSwift
import RxCocoa

class NewsListViewModel: DRxTableViewDelegate {
    
    // MARK: - Properties
    
    /// TableView
    let tableView = DRxTableView()
    
    /// RxSwift DisposeBag
    private let disposeBag = DisposeBag()
    
    /// ActionCell 专用的 DisposeBag
    private var actionCellDisposeBag = DisposeBag()
    
    /// 数据源
    private let sections = BehaviorRelay<[SectionModel]>(value: [])
    
    /// 加载状态
    private let loadingState = BehaviorRelay<DRxLoadingState>(value: .none)
    
    private var additionalNewsCount = 0
    private let maxAdditionalNews = 10
    
    // MARK: - Outputs
    
    /// 数据源序列
    var sectionsOutput: Observable<[SectionModel]> {
        return sections.asObservable()
    }
    
    /// 加载状态序列
    var loadingStateOutput: Observable<DRxLoadingState> {
        return loadingState.asObservable()
    }
    
    // MARK: - Initialization
    
    init() {
        print("=== NewsListViewModel init ===")
        
        // 设置 tableView 属性
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.enableHeightCache = true
        
        setupBindings()
        loadMockData()
        print("=== NewsListViewModel init end ===")
    }
    
    private func setupBindings() {
        // 绑定数据源
        sectionsOutput
            .bind(onNext: { [weak self] sections in
                self?.tableView.updateData(sections)
            })
            .disposed(by: disposeBag)
        
        // 绑定下拉刷新
        tableView.rx.headerRefreshing
            .subscribe(onNext: { [weak self] in
                self?.refreshData()
            })
            .disposed(by: disposeBag)
        
        // 绑定上拉加载
        tableView.rx.footerRefreshing
            .subscribe(onNext: { [weak self] in
                self?.loadMoreData()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleNestedCellExpand(_ model: NewsModel) {
        // 切换展开状态
        model.toggleExpand()
        
        // 计算新的高度
        let newHeight = model.calculateNestedHeight(isExpanded: model.isExpanded.value)
        
        // 找到对应的 indexPath
        for (sectionIndex, section) in sections.value.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.identifier == model.identifier }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                
                // 使用 performBatchUpdates 来同步更新状态和高度
                tableView.performBatchUpdates({
                    // 更新高度
                    model.updateHeight(newHeight, animated: true)
                }, completion: { _ in
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
                break
            }
        }
    }
    
    // MARK: - DRxTableViewDelegate
    
    func tableView(_ tableView: UITableView, didGetCell cell: UITableViewCell, at indexPath: IndexPath) {
        print("\n=== didGetCell called ===")
        print("Cell type: \(type(of: cell))")
        print("IndexPath: \(indexPath)")
        
        // 处理 ActionCell
        if let actionCell = cell as? NewsActionCell {
            print("Found ActionCell at indexPath: \(indexPath)")
            
            // 使用 tag 避免重复订阅
            let tag = indexPath.section * 1000 + indexPath.row
            if actionCell.tag != tag {
                actionCell.tag = tag
                print("设置新的 tag: \(tag)")
                
                // 清理当前的订阅
                actionCellDisposeBag = DisposeBag()
                
                // 重新订阅事件
                actionCell.eventRelay
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { event in
                        print("接收到 ActionCell 事件: \(event)")
                    })
                    .subscribe(onNext: { [weak self] event in
                        print("开始处理 ActionCell 事件: \(event)")
                        switch event {
                        case .delete(let model):
                            self?.handleDeleteAction(model)
                        case .addImage(let model):
                            self?.handleAddImageAction(model)
                        }
                    })
                    .disposed(by: actionCellDisposeBag)  // 使用专门的 DisposeBag
                
                // 配置 cell
                if let model = self.sections.value[indexPath.section].cells[indexPath.row] as? NewsModel {
                    print("配置 ActionCell，model identifier: \(model.identifier)")
                    actionCell.configure(with: model)
                }
            }
        }
        
        // 处理 NewsTextInputCell
        if let textInputCell = cell as? NewsTextInputCell {
            print("Found NewsTextInputCell")
            let sections = self.sections.value
            guard indexPath.section < sections.count,
                  let model = sections[indexPath.section].cells[indexPath.row] as? NewsModel else {
                print("Model not found for NewsTextInputCell")
                return
            }
            print("Found model for NewsTextInputCell")
            textInputCell.configure(with: model)
        }
        
        // 处理 NewsNestedCell
        if let nestedCell = cell as? NewsNestedCell {
            let tag = indexPath.section * 1000 + indexPath.row
            if nestedCell.tag != tag {
                nestedCell.tag = tag
                nestedCell.configure(with: sections.value[indexPath.section].cells[indexPath.row] as! NewsModel)
                
                // 订阅展开/收起事件
                nestedCell.eventRelay
                    .subscribe(onNext: { [weak self] event in
                        if case .toggleExpand(let model) = event {
                            self?.handleNestedCellExpand(model)
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didGetHeaderView view: UIView, in section: Int) {
        // 不需要实现
    }
    
    func tableView(_ tableView: UITableView, didGetFooterView view: UIView, in section: Int) {
        // 不需要现
    }
    
    // MARK: - Private Methods
    
    /// 加载 mock 数据
    private func loadMockData() {
        // 创建 mock 数据
        let mockNews1 = [
            NewsModel(
                title: "苹果发布 iPhone 15 系列",
                content: "苹果公司今日发布了全新的 iPhone 15 系列，包括标准版、Plus、Pro 和 Pro Max 四个型号。",
                imageURL: "https://img1.baidu.com/it/u=550609510,4201580069&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500",
                date: Date(),
                delegate: tableView
            ),
            NewsModel(
                title: "特斯拉推出新款 Model S",
                content: "特斯拉发布新款 Model S，续航里程突破 600 公里，0-100km/h 加速仅需 2.1 秒。",
                imageURL: "https://img0.baidu.com/it/u=3350411928,213627080&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                date: Date().addingTimeInterval(-3600),
                delegate: tableView
            ),
            NewsModel(
                title: "热门科技新闻",
                content: "",
                imageURL: "",
                date: Date().addingTimeInterval(-7200),
                cellType: .nested,
                subItems: [
                    NewsSubItem(
                        title: "谷歌发布 AI 模型",
                        subtitle: "性能提升超过 50%"
                    ),
                    NewsSubItem(
                        title: "Meta 推出新款 VR 设备",
                        subtitle: "售价 499 美元起"
                    ),
                    NewsSubItem(
                        title: "微软发布 Windows 12",
                        subtitle: "全新设计和 AI 助手"
                    )
                ],
                isExpanded: false, // 默认收起状态
                delegate: tableView
            ),
            NewsModel(
                title: "SpaceX 成功发射星链卫星",
                content: "SpaceX 今日成功发射新一批星链卫星，进一步扩大全球互联网覆盖范围。",
                imageURL: "https://img0.baidu.com/it/u=2917508332,2227941891&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                date: Date().addingTimeInterval(-10800),
                cellType: .image,
                delegate: tableView
            ),
            NewsModel(
                title: "微软收购动视暴雪完成",
                content: "微软以 687 亿美元收购动视暴雪的交易正式完成，游戏行业格局将发生重大���化。",
                imageURL: "https://img0.baidu.com/it/u=2917508332,2227941891&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                date: Date().addingTimeInterval(-14400),
                cellType: .image,
                delegate: tableView
            )
        ]

        let mockNews2 = [
            NewsModel(
                title: "入文字",
                content: "",
                imageURL: "",
                date: Date(),
                cellType: .textInput,
                delegate: tableView
            ),
            NewsModel(
                title: "",
                content: "",
                imageURL: "",
                date: Date(),
                cellType: .action,
                delegate: tableView
            ),
            NewsModel(
                title: "更多科技新闻",
                content: "",
                imageURL: "",
                date: Date().addingTimeInterval(-7200),
                cellType: .nested,
                subItems: [
                    NewsSubItem(
                        title: "苹果发布新款 MacBook",
                        subtitle: "性能提升显著"
                    ),
                    NewsSubItem(
                        title: "亚马逊推出新服务",
                        subtitle: "Prime 会员专享"
                    ),
                    NewsSubItem(
                        title: "特斯拉发布新电池技术",
                        subtitle: "续航里程大幅提升"
                    )
                ],
                isExpanded: false, // 默认收起状态
                delegate: tableView
            )
        ]

        // 创建 section
        let section1 = SectionModel(
            identifier: "news1",
            header: HeaderViewModel(title: "科技新闻"),
            cells: mockNews1,
            footer: FooterViewModel(),
            type: "default"
        )
        
        let section2 = SectionModel(
            identifier: "news2",
            header: HeaderViewModel(title: "其他新闻"),
            cells: mockNews2,
            footer: FooterViewModel(),
            type: "default"
        )
        
        sections.accept([section1, section2])
    }
    
    // 添加常量定义
    private enum Constants {
        static let maxImageCells = 5
    }
    
    // 添加辅助方法来计算图片 cell 数量
    private func countImageCells(in cells: [DRxModelProtocol]) -> Int {
        return cells.filter { cell in
            if let newsModel = cell as? NewsModel {
                print("Cell type: \(newsModel.cellType), isImage: \(newsModel.cellType == .image)")
                return newsModel.cellType == .image
            }
            return false
        }.count
    }
    
    // 理删除事件
    private func handleDeleteAction(_ model: NewsModel) {
        print("开始处理删除事件")
        if var currentSections = sections.value.last {
            let currentImageCells = countImageCells(in: currentSections.cells)
            print("当前图片 cell 数量: \(currentImageCells)")
            
            if currentImageCells == 0 {
                print("没有可删除的图片")
                tableView.makeToast("没有更多数据可以删除")
                return
            }
            
            // 从后往前找最后一个图片 cell
            if let lastImageIndex = currentSections.cells.indices.reversed().first(where: { index in
                if let newsModel = currentSections.cells[index] as? NewsModel {
                    return newsModel.cellType == .image
                }
                return false
            }) {
                print("找到要删除的图片 cell，index: \(lastImageIndex)")
                
                // 删除数据源中的 cell
                currentSections.cells.remove(at: lastImageIndex)
                
                // 更新数据源
                var updatedSections = sections.value
                updatedSections[updatedSections.count - 1] = currentSections
                sections.accept(updatedSections)
                
                // 刷新 tableView
                tableView.performBatchUpdates({
                    tableView.reloadData()
                }, completion: { _ in
                    // 显示 toast 提示
                    self.tableView.makeToast("已删除 indexPath: \(updatedSections.count - 1)-\(lastImageIndex) 的 cell")
                })
                
                print("删除完成，剩余图片 cell 数量: \(currentImageCells - 1)")
            }
        }
    }
    
    // 处理添加图片事件
    private func handleAddImageAction(_ model: NewsModel) {
        print("开始处理添加事件")
        if var currentSections = sections.value.last {
            let currentImageCells = countImageCells(in: currentSections.cells)
            print("当前图片 cell 数量: \(currentImageCells)")
            
            if currentImageCells >= 3 {
                print("已达到上限")
                tableView.makeToast("最多只能添加3个图片")
                return
            }
            
            // 创建新的图片新闻模型
            let newImageModel = NewsModel(
                title: "新增的图片新闻 \(currentImageCells + 1)",  // 添加序号
                content: "这是一新增的图片新闻示例。",
                imageURL: "https://img0.baidu.com/it/u=2917508332,2227941891&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
                date: Date(),
                cellType: .image,
                delegate: tableView
            )

            // 插入到 cells 中
            currentSections.cells.append(newImageModel)
            
            // 更新数据源
            var updatedSections = sections.value
            updatedSections[updatedSections.count - 1] = currentSections
            sections.accept(updatedSections)
            
            // 刷新 tableView
            tableView.performBatchUpdates({
                tableView.reloadData()
            }, completion: nil)
            
            print("添加完成，当前图片 cell 数量: \(currentImageCells + 1)")
        }
    }
    
    private func refreshData() {
        // 重置页面数据
        loadMockData()
        tableView.endHeaderRefreshing()
    }
    
    private func loadMoreData() {
        guard additionalNewsCount < maxAdditionalNews else {
            tableView.makeToast("没有更多数据")
            tableView.noMoreData()
            return
        }

        // 创建新的新闻模型
        let newNewsModel = NewsModel(
            title: "新增的新闻 \(additionalNewsCount + 1)",
            content: "这是新增的新闻示例。",
            imageURL: "https://img0.baidu.com/it/u=2917508332,2227941891&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
            date: Date(),
            cellType: .image,
            delegate: tableView
        )

        // 创建新的 section
        let newSection = SectionModel(
            identifier: "newSection\(additionalNewsCount)",
            header: HeaderViewModel(title: "新增新闻"),
            cells: [newNewsModel],
            footer: FooterViewModel(),
            type: "default"
        )

        // 更新数据源
        var currentSections = sections.value
        currentSections.append(newSection)
        
        // 刷新 tableView
        tableView.performBatchUpdates({
            sections.accept(currentSections) // 确保在插入 section 之前更新数据源
            let newSectionIndex = currentSections.count - 1
            tableView.insertSections(IndexSet(integer: newSectionIndex), with: .automatic)
        }, completion: { _ in
            self.tableView.endFooterRefreshing() // 确保结束刷新动画
        })

        additionalNewsCount += 1
    }
} 
