//
//  DzwTestTabVM.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabVM.h"
#import "DzwTestTabModel.h"
#import "DzwTestTabModel2.h"
#import "DzwTestTabCell.h"
#import "DzwTestTabCell_2.h"
#import "DzwTestTabCell_3.h"
#import "DzwTestTabCell_4.h"
#import "DzwTestSubCell.h"
#import "DzwTestSectionHeader.h"
#import "DzwTestSectionFooter.h"
#import "DzwTestResponsechainCell.h"

@interface DzwTestTabVM ()

#pragma mark - Private Properties
@property (nonatomic, copy, readwrite) NSArray *models;
@property (nonatomic, copy, readwrite) NSArray *sectionHeaderModels;
@property (nonatomic, copy, readwrite) NSArray *sectionFooterModels;

@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign, readwrite) BOOL hasMoreData;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, strong, readwrite) RACCommand *loadDataCommand;
@property (nonatomic, strong, readwrite) RACCommand *loadMoreCommand;
@property (nonatomic, strong, readwrite) RACCommand *refreshCommand;
@property (nonatomic, strong, readwrite) RACCommand *cellDidSelectCommand;
@property (nonatomic, strong, readwrite) RACCommand *cellButtonTapCommand;
@property (nonatomic, strong, readwrite) RACCommand *cellFoldCommand;
@property (nonatomic, strong, readwrite) RACCommand *textViewChangedCommand;

@property (nonatomic, strong, readwrite) RACSignal *loadingStateSignal;
@property (nonatomic, strong, readwrite) RACSignal *errorSignal;

@end

@implementation DzwTestTabVM

#pragma mark - Lifecycle
- (instancetype)init {
    if (self = [super init]) {
        [self setupInitialState];
        [self setupCommands];
        [self setupSignals];
    }
    return self;
}

#pragma mark - Setup Methods
- (void)setupInitialState {
    self.models = @[];
    self.sectionHeaderModels = @[];
    self.sectionFooterModels = @[];
    self.isLoading = NO;
    self.hasMoreData = YES;
    self.error = nil;
}

- (void)setupCommands {
    [self setupDataCommands];
    [self setupCellCommands];
}

- (void)setupDataCommands {
    @weakify(self);
    
    // 数据加载Command
    self.loadDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loadDataSignal];
    }];
    
    // 加载更多Command
    self.loadMoreCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@(self.hasMoreData)] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loadMoreDataSignal];
    }];
    
    // 刷新Command
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self refreshDataSignal];
    }];
}

- (void)setupCellCommands {
    @weakify(self);
    
    // Cell选择Command
    self.cellDidSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACThreeTuple<UITableView *, NSIndexPath *, id<RACModelDelegate>> *input) {
        @strongify(self);
        return [self handleCellSelection:input];
    }];
    
    // Cell按钮点击Command
    self.cellButtonTapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        return [self handleCellButtonTap:input];
    }];
    
    // Cell折叠Command
    self.cellFoldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        return [self handleCellFold:input];
    }];
    
    // TextView变化Command
    self.textViewChangedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *text) {
        @strongify(self);
        return [self handleTextViewChanged:text];
    }];
}

- (void)setupSignals {
    // 加载状态信号
    self.loadingStateSignal = [RACSignal merge:@[
        self.loadDataCommand.executing,
        self.loadMoreCommand.executing,
        self.refreshCommand.executing
    ]];
    
    // 错误信号
    self.errorSignal = [RACSignal merge:@[
        self.loadDataCommand.errors,
        self.loadMoreCommand.errors,
        self.refreshCommand.errors
    ]];
    
    // 绑定loading状态
    RAC(self, isLoading) = self.loadingStateSignal;
}

#pragma mark - Signal Processing Methods
- (RACSignal *)loadDataSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 数据模拟请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                // 后台线程：模拟网络请求等耗时操作
                NSLog(@"🔄 Loading data in background thread...");
                
                // 切换回主线程：执行UI相关的数据模型更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performDataLoading];
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                });
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [subscriber sendError:[NSError errorWithDomain:@"DataLoadingError" code:1001 userInfo:@{NSLocalizedDescriptionKey: exception.reason}]];
                });
            }
        });
        return nil;
    }];
}

- (RACSignal *)loadMoreDataSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 数据模拟请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSLog(@"📱 [VM] 执行加载更多数据逻辑");
                
                // 切换回主线程：执行可能影响UI的操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 这里可以添加实际的分页加载逻辑
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                });
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [subscriber sendError:[NSError errorWithDomain:@"LoadMoreError" code:1002 userInfo:@{NSLocalizedDescriptionKey: exception.reason}]];
                });
            }
        });
        return nil;
    }];
}

- (RACSignal *)refreshDataSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 数据模拟请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSLog(@"🔄 Refreshing data in background thread...");
                
                // 切换回主线程：执行UI相关的数据模型更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performDataLoading];
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                });
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [subscriber sendError:[NSError errorWithDomain:@"RefreshError" code:1003 userInfo:@{NSLocalizedDescriptionKey: exception.reason}]];
                });
            }
        });
        return nil;
    }];
}

- (RACSignal *)handleCellSelection:(RACThreeTuple<UITableView *, NSIndexPath *, id<RACModelDelegate>> *)input {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UITableView *tableView = input.first;
        NSIndexPath *indexPath = input.second;
        id<RACModelDelegate> cellModel = input.third;
        
        NSLog(@"🌗🌗[VM-CellSelection] 点击了cell 序列号：%ld-%ld", (long)indexPath.section, (long)indexPath.row);
        
        // 可以在这里添加页面跳转、详情展示等逻辑
        // [self navigateToDetailWithModel:cellModel];
        
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)handleCellButtonTap:(RACTuple *)input {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"🌗🌗[VM-ButtonTap] Cell按钮被点击");
        
        // 可以在这里添加具体的按钮处理逻辑
        // 比如收藏、点赞、分享等操作
        
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)handleCellFold:(RACTuple *)input {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"🌗🌗[VM-CellFold] Cell折叠状态改变");
        
        // 处理cell折叠/展开逻辑
        // 可能需要更新数据源并触发UI刷新
        
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)handleTextViewChanged:(NSString *)text {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"🌗🌗[VM-TextChanged] TextView内容改变：%@", text);
        
        // 处理文本变化逻辑
        // 比如自动保存、实时搜索等
        
        [subscriber sendNext:text];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - Data Loading Logic
- (void)performDataLoading {
    // 重构原有的数据加载逻辑
    [self loadTestData];
}

#pragma mark - 组装cell和header、footer数据源
- (void)loadTestData {
    //测试cell高度自适应的例子
    //[self loadData_case2];
    //return;
    
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    //cell数据源
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<4; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd1 = [[DzwTestTabModel alloc]init];
        cellMd1.imageUrl = @"https://pic1.zhimg.com/80/v2-e75d29123341343bb53fbe6c251499f2_r.jpg";
        cellMd1.titleString = @"标题：row 1";
        cellMd1.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        //测试不给高度 自适应高度
        cellMd1.cellNib = [DzwTestTabCell_2 class];
        [t_modelsArr addObject:cellMd1];

        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"标题：row 2";
        cellMd2.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        DzwTestTabModel *cellMd3 = [[DzwTestTabModel alloc]init];
        cellMd3.cellNib = [DzwTestResponsechainCell class];
        cellMd3.cellHeight = @(64);
        [t_modelsArr addObject:cellMd3];
        
        DzwTestTabModel *cellMd4 = [[DzwTestTabModel alloc]init];
        cellMd4.imageUrl = @"img_elective_finish";
        cellMd4.titleString = @"cell内嵌textview高度自适应";
        cellMd4.cellNib = [DzwTestTabCell_4 class];
        cellMd4.cellHeight = @(UITableViewAutomaticDimension);
        [t_modelsArr addObject:cellMd4];

        DzwTestTabModel2 *cell3Md = [self getTestMd2];
        [t_modelsArr addObject:cell3Md];
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];

    //sectionHeader数据源
    NSMutableArray *headerArr = [NSMutableArray array];
    DzwTestTabModel *headerMd1 = [[DzwTestTabModel alloc]init];
    headerMd1.titleString = @"头部标题：section 0";
    headerMd1.detailString = @"头部详情：section 0";
    headerMd1.sectionHeaderHeight = @(kScale_W(80));
    headerMd1.sectionHeaderClass = [DzwTestSectionHeader class];
    [headerArr addObject:headerMd1];

    DzwTestTabModel *headerMd2 = [[DzwTestTabModel alloc]init];
    headerMd2.titleString = @"头部标题：section 1";
    headerMd2.detailString = @"头部详情：section 1";
    headerMd2.sectionHeaderHeight = @(kScale_W(80));
    headerMd2.sectionHeaderClass = [DzwTestSectionHeader class];
    [headerArr addObject:headerMd2];
    self.sectionHeaderModels = [NSArray arrayWithArray:headerArr];

    //sectionFooter数据源
    NSMutableArray *footerArr = [NSMutableArray array];
    DzwTestTabModel *footerMd1 = [[DzwTestTabModel alloc]init];
    footerMd1.titleString = @"尾部标题：section 0";
    footerMd1.detailString = @"尾部详情：section 0";
    footerMd1.sectionFooterHeight = @(kScale_W(80));
    footerMd1.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd1];

    DzwTestTabModel *footerMd_empty = [DzwTestTabModel new];
    [footerArr addObject:footerMd_empty];

    DzwTestTabModel *footerMd2 = [[DzwTestTabModel alloc]init];
    footerMd2.titleString = @"尾部标题：section 2";
    footerMd2.detailString = @"尾部详情：section 2";
    footerMd2.sectionFooterHeight = @(kScale_W(80));
    footerMd2.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd2];

    DzwTestTabModel *footerMd3 = [[DzwTestTabModel alloc]init];
    footerMd3.titleString = @"尾部标题：section 3";
    footerMd3.detailString = @"尾部详情：section 3";
    footerMd3.sectionFooterHeight = @(kScale_W(80));
    footerMd3.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd3];
    self.sectionFooterModels = [NSArray arrayWithArray:footerArr];
}

#pragma mark - 兼容方法 (Compatibility Methods)
/// 向后兼容的数据加载方法
- (void)loadData {
    [self.loadDataCommand execute:nil];
}

- (void)loadMore {
    [self.loadMoreCommand execute:nil];
}

- (void)loadData_case2{
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
    

}


- (DzwTestTabModel2 *)getTestMd2{
    DzwTestTabModel2 *md = [DzwTestTabModel2 new];
    md.titleString = @"cell内嵌tableView";
    CGFloat height = 0;
    
    NSMutableArray *subModels = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        NSString *subTitle = [NSString stringWithFormat:@"首次揭示PD-L1/PD-1通路在肿瘤微环境免疫逃逸中的作用并首创以抗体阻断PD-1/PD-L1通路治疗癌症的方法，由于这些贡献他在2014年获得全球免疫学界最高奖项William B. Coley Award\n----------------------------------------------\n测试row：%d\n ----------------------------------------------",i];
        CGFloat subCellHeight = [DzwTool getRectByWidth:SCREEN_WIDTH-kScale_W(40) string:subTitle font:kFontWithName(kMedFont, 13.f)].size.height+kScale_W(20);
        height += subCellHeight;
        md.cellHeight = @(height+kScale_W(44)+kScale_W(10));
        
        DzwTestTabModel *md = [DzwTestTabModel new];
        md.cellClass = [DzwTestSubCell class];
        //内嵌cell的高度
        md.cellHeight = @(subCellHeight);
        md.titleString = subTitle;
        [subModels addObject:md];
    }

    md.cellNib = [DzwTestTabCell_3 class];
    md.subCellData = [NSArray arrayWithArray:subModels];
    return md;
}

@end
