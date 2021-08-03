# RACTableView
当前是demo工程，通用性的tableview的封装方案尝试。未支持cocoapod


### 解决什么问题？
1. 面对简单的列表，我们需要重复写tableView的delegate和DataSource的代码，试图减少节省这部分重复的工作。
2. 面对复杂列表，我们在MVC下会让控制器变得臃肿，所以采用了MVVM的结构，分离业务逻辑到vm，rac作为数据绑定方案，把逻辑代码集中，避免结构混乱的问题。
3. cell高度计算或自适应问题。a.可以使用自定义计算高度，将会对高度进行缓存。b.支持使用系统UITableViewAutomaticDimension，虽然不建议使用这种方式进行自适应。c.使用https://github.com/forkingdog/UITableView-FDTemplateLayoutCell 进行高度自适应，cell使用autolayout进行布局。因此引入了依赖masonry。

### 使用

主要想法：一切变动都是基于数据变化来驱动，核心工作量转移到数据操作中来，cellmodel的属性决定cell的最终呈现的状态。具体参考工程中的 `demo`.

1.vc中只需要进行基本的初始化工作

```
@property (nonatomic, strong) ZGRacTableView *tableView;

...
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
```



```objective-c
- (ZGRacTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZGRacTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //ZGRacTableViewDelegate代理
        _tableView.rac_delegate = self;
    }
    return _tableView;
}
```



a. 如果需要获取cell或者header、footer的实例 提供了`ZGRacTableViewDelegate` 可以获取对应indexpath的实例和相关联的数据源，参考上面`_tableView.rac_delegate = self;`

```objective-c
@protocol ZGRacTableViewDelegate <NSObject>
@optional;
/**
 在需要的时候获取指定index的cell、header、footer实例
 例如：cell内有按钮 需要传递事件到外层使用
      可以实现这个代理获取cell实例传递点击事件到vc或vm、
 */
- (void)rac_ableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)rac_ableView:(UITableView *)tableView headerView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section;
- (void)rac_ableView:(UITableView *)tableView footerView:(UIView *)footerView viewForFooterInSection:(NSInteger)section;
@end
```

b. 一般情况下不需要实现Delegate和DataSource,如果当前的封装无法满足你的需求，可以将`RACTableView`作为一般的`UITableView`使用。像一般的用法一样将当前vc作为代理实现tableview相关代理`UITableViewDelegate` 或 数据源协议`UITableViewDataSource`就可以了,会优先以VC中实现的代理为准。



2.vm中准备好数据源 在vc中监听数据源和刷新列表就好

```objective-c
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    //cell数据源
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<1; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"标题：row 2";
        cellMd2.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        cellMd2.cellHeight = @(kScale_W(120));
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];
```

3.model需要遵循`ZGRacModelDelegate`协议，才能使用它定义的cell相关的扩展属性，扩展属性的具体使用参考相关的.h注释 例如：

```objective-c
@interface DzwTestTabModel : NSObject<ZGRacModelDelegate>

... 
  #协议中已定义的扩展属性
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

4.在第二步中的`DzwTestTabCell`，是你自定义的cell，它可以支持纯代码或者xib，在cell中绑定模型，监听模型变化就好。

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

这样一个完整的tableview就构建完成了。



文档写的比较简单，.h注释就是最好的文档。
