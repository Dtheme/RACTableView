# RACTableView

[中文](https://github.com/Dtheme/RACTableView/blob/main/README.md) | [English](https://github.com/Dtheme/RACTableView/blob/main/README-en.md)

---

`RACTableView` 是一个演示项目，提供了一种在 iOS 应用中封装通用 TableView 的解决方案。该方案可以减少冗余代码，提升代码的可维护性，同时提高 TableView 中事件处理的灵活性。

## 为什么要使用 RACTableView？

1. **减少冗余代码**：对于简单列表，`RACTableView` 消除了重复实现 `tableView` 代理和数据源方法的需求，节省时间并减少冗余代码。
2. **防止控制器臃肿**：在复杂的列表场景下，MVC 架构容易导致控制器过于臃肿。通过采用 MVVM 架构，我们将业务逻辑分离到 ViewModel 中，并使用 ReactiveCocoa（RAC）进行数据绑定。这种方式使逻辑集中，避免结构混乱。
3. **单元格高度计算与 Auto Layout**：
   - 支持自定义高度计算，具有缓存机制以提高性能。
   - 支持系统提供的 `UITableViewAutomaticDimension`（不推荐用于复杂布局）。
   - 集成 [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) 实现 Auto Layout 自动高度，布局依赖 **Masonry**。

## 安装

你可以通过以下两种方式安装 `RACTableView`：

1. **手动安装**：将 `RACTableView` 文件夹中的文件拷贝到你的项目中。
2. **使用 CocoaPods**（待支持时）：在 `Podfile` 中添加以下代码：
   ```ruby
   pod 'RACTableView', '~> 1.0.0'
   ```

## 使用方法

**核心思路**：所有的变化都是数据驱动的，核心工作集中在数据处理上。`cellModel` 的属性决定了每个单元格的最终状态。具体实现细节请参考 Demo 项目。

### 1. 在 ViewController 中进行基本初始化

```objc
@property (nonatomic, strong) ZGRacTableView *tableView;

...
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
```

```objc
- (ZGRacTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZGRacTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // 设置 ZGRacTableViewDelegate
        _tableView.rac_delegate = self;
    }
    return _tableView;
}
```

### 2. 在单元格中处理按钮事件

a. 如果需要访问单元格、头部或尾部的实例，`ZGRacTableViewDelegate` 提供了获取指定索引的实例及相关数据的方法：

```objc
@protocol ZGRacTableViewDelegate <NSObject>
@optional;
/**
 获取指定索引的单元格、头部或尾部实例。
 当需要将单元格中的按钮点击事件传递到 ViewController 或 ViewModel 时非常有用。
 */
- (void)rac_tableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)rac_tableView:(UITableView *)tableView headerView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section;
- (void)rac_tableView:(UITableView *)tableView footerView:(UIView *)footerView viewForFooterInSection:(NSInteger)section;
@end
```

b. 在大多数情况下，你无需实现 `Delegate` 和 `DataSource` 方法。如果 `RACTableView` 无法满足你的需求，也可以将其作为普通的 `UITableView` 使用，设置视图控制器为其代理并实现 `UITableViewDelegate` 或 `UITableViewDataSource`。

### 3. 在 ViewModel 中准备数据源

在 ViewModel 中设置数据源，然后在视图控制器中监听并刷新 TableView。

```objective-c
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    // 设置单元格数据源
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<1; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"标题: 第 2 行";
        cellMd2.detailString = [NSString stringWithFormat:@"详情: 第 %d 节",i];
        cellMd2.cellHeight = @(kScale_W(120));
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];
```

### 4. 确保 Model 遵循 `ZGRacModelDelegate` 协议

要使用与单元格相关的扩展属性，模型需要遵循 `ZGRacModelDelegate` 协议。具体使用细节请参考 `.h` 文件中的注释。例如：

```objc
@interface DzwTestTabModel : NSObject<ZGRacModelDelegate>

...
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellClass;
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellNib;
@property (nonatomic, copy, nullable) NSString *cellReuseIdentifier;
@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, assign) BOOL isfold;
```

### 5. 在自定义 Cell 中绑定数据

在自定义 Cell 中将数据绑定到视图上，并监听数据变化：

```objective-c
- (void)bindingCellData{
    @weakify(self);
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel * _Nullable model) {
        @strongify(self);
        self.imageV.image = kGetImageNamed(model.imageUrl);
        self.titleLb.text = model.titleString;
        self.detailLb.text = model.detailString;
    }];
}
```

---

### 推荐使用

建议使用 [DzwEventRouter](https://github.com/Dtheme/DzwEventRouter) 来处理交互事件，避免使用反向代理。它可以替代以下方法：

```
- (void)rac_tableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

---

**文档较为简洁，详细使用请参考 `.h` 文件的注释。**



add:
增加了swift版本：[DRxTableView](https://github.com/Dtheme/RACTableView/RACTableView-Swift)
swift版本使用，请参考[DRxTableView](https://github.com/Dtheme/RACTableView/RACTableView-Swift/RACTableView-Swift/Examples)
swift版本并非对oc版本的简单翻译，而是重新设计，使用方式和oc版本有较大差异，高度结合swift语言特性以及rxswift
