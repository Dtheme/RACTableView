# RACTableView

[中文](https://github.com/Dtheme/RACTableView/blob/main/README.md) | [English](https://github.com/Dtheme/RACTableView/blob/main/README-en.md)
---

`RACTableView` is a demo project providing a solution for encapsulating generic table views in iOS applications. This solution reduces redundancy, enhances code maintainability, and improves flexibility in event handling within table views. Currently, CocoaPods is not supported.

## Problems Solved

1. **Reducing Redundant Code**: For simple lists, `RACTableView` eliminates the need to repeatedly implement the `tableView` delegate and data source methods, saving time and reducing redundant code.
2. **Preventing View Controller Bloat**: In complex lists, the MVC architecture can lead to bloated controllers. By adopting the MVVM structure, we separate business logic into the view model, using ReactiveCocoa (RAC) for data binding. This approach centralizes logic and prevents structural confusion.
3. **Cell Height Calculation and Auto Layout**:
    - Custom height calculations with caching for performance.
    - Support for system-provided `UITableViewAutomaticDimension` (not recommended for complex layouts).
    - Integration with [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) for auto-sizing cells with Auto Layout, with **Masonry** as a layout dependency.

## Installation

You can install `RACTableView` in two ways:

1. **Manual Installation**: Copy the files in the `RACTableView` folder directly into your project.
2. **Using CocoaPods** (when supported): Add the following line to your `Podfile`:
   ```ruby
   pod 'RACTableView', '~> 1.0.0'
   ```

## Usage

**Main Idea**: All changes are data-driven, shifting the core workload to data manipulation. The properties of `cellModel` dictate the final state of each cell. For specific implementation details, refer to the demo project.

### 1. Basic Initialization in the ViewController

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
        // Setting ZGRacTableViewDelegate
        _tableView.rac_delegate = self;
    }
    return _tableView;
}
```

### 2. Handling Button Actions within Cells

a. If you need to access the instances of cells, headers, or footers, `ZGRacTableViewDelegate` provides methods to retrieve instances and their associated data for a given `indexPath`. 

```objc
@protocol ZGRacTableViewDelegate <NSObject>
@optional;
/**
 Retrieve instances of specified index cells, headers, or footers.
 Useful when needing to pass button click events from within a cell to 
 the view controller or view model.
 */
- (void)rac_tableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)rac_tableView:(UITableView *)tableView headerView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section;
- (void)rac_tableView:(UITableView *)tableView footerView:(UIView *)footerView viewForFooterInSection:(NSInteger)section;
@end
```

b. For most use cases, it’s not necessary to implement Delegate and DataSource methods. If `RACTableView` doesn’t meet your requirements, you can still use it as a standard `UITableView`, setting the view controller as its delegate and implementing `UITableViewDelegate` or `UITableViewDataSource`.

### 3. Prepare the Data Source in the View Model  

Set up the data source in the view model, then observe it in the view controller to refresh the table view.

```objective-c
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    // Set up cell data source
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<1; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"Title: row 2";
        cellMd2.detailString = [NSString stringWithFormat:@"Details: section %d",i];
        cellMd2.cellHeight = @(kScale_W(120));
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];
```

### 4. Ensuring Model Conforms to `ZGRacModelDelegate` Protocol  

To use cell-related extended properties, models need to conform to the `ZGRacModelDelegate` protocol. Refer to `.h` file comments for detailed usage of each property. For example:

```objc
@interface DzwTestTabModel : NSObject<ZGRacModelDelegate>

...
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellClass;
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellNib;
@property (nonatomic, copy, nullable) NSString *cellReuseIdentifier;
@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, assign) BOOL isfold;

@property (nonatomic, unsafe_unretained) Class<ZGRacSectionViewDelegate> sectionHeaderClass;
@property (nonatomic, strong) NSNumber *sectionHeaderHeight;

@property (nonatomic, unsafe_unretained) Class<ZGRacSectionViewDelegate> sectionFooterClass;
@property (nonatomic, strong) NSNumber *sectionFooterHeight;
```

### 5. Bind Data in Custom Cell  

In Step 3, `DzwTestTabCell` is your custom cell, implemented either with pure code or a XIB. Simply bind the model in the cell and observe changes. If the cell is XIB-based, set `cellMd2.cellNib = [DzwTestTabCell class];`. For code-based cells, set `cellMd2.cellClass = [DzwTestTabCell class];`. Only one of `cellClass` or `cellNib` will take effect. ❗️If both are set, `cellNib` will override `cellClass`.

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

This completes the construction of a fully functional table view.

### Strongly Recommended ###
Consider using [DzwEventRouter](https://github.com/Dtheme/DzwEventRouter) to handle interaction events and avoid reverse delegation. This can replace the following methods:

```
- (void)rac_tableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)rac_tableView:(UITableView *)tableView headerView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section;
- (void)rac_tableView:(UITableView *)tableView footerView:(UIView *)footerView viewForFooterInSection:(NSInteger)section;
```

The documentation is brief; refer to comments in the `.h` files for more details.
