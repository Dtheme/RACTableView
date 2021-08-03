# RACTableView
当前是demo工程。未支持cocoapod

demo工程中包含的内容：1.基于RAC的mvvm结构封装UITableView。2.基于YTKNetwork和RAC的网络请求基础类。3.demo代码

### 解决什么问题？
1. 面对简单的列表，我们需要重复写tableView的delegate和DataSource的代码，试图减少节省这部分重复的工作。
2. 面对复杂列表，我们在MVC下会让控制器变得臃肿，所以采用了MVVM的结构，分离业务逻辑到vm，rac作为数据绑定方案，把逻辑代码集中，避免结构混乱的问题。
3. cell高度计算或自适应问题。a.可以使用自定义计算高度，将会对高度进行缓存。b.支持使用系统UITableViewAutomaticDimension，虽然不建议使用这种方式进行自适应。c.使用https://github.com/forkingdog/UITableView-FDTemplateLayoutCell进行高度自适应，cell使用autolayout进行布局。因此引入了依赖masonry。

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
        _tableView.rac_delegate = self;
    }
    return _tableView;
}
```

一般情况下不需要实现UITableViewDelegate和DataSource

如果当前的封装无法满足需求的时候，RACTableView可以原封不动的当做UITableView使用。

2.vm中准备好数据源 在vc中监听刷新就好

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



文档写的比较简单，.h注释就是最好的文档。
