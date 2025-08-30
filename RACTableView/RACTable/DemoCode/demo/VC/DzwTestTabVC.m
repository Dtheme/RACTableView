//
//  DzwTestTabV.m
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabVC.h"
#import "DzwTestTabVM.h"
#import "YYFPSLabel.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"
#import "UITableView+RACTableView.h"
#import "DzwTestTabCell.h"
#import "DzwTestTabCell_2.h"
#import "DzwTestTabCell_3.h"
#import "DzwTestTabCell_4.h"
#import "DzwTestSubCell.h"
#import "DzwTestSectionHeader.h"
#import "DzwTestSectionFooter.h"
#import "DzwTestResponsechainCell.h"
#import "DzwTestCellViewModel.h"
@interface DzwTestTabVC ()<RACTableViewDelegate>
@property (nonatomic, strong) DRacTableView *tableView;
@property (nonatomic, strong) DzwTestTabVM *viewModel;
@end

@implementation DzwTestTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModelBindings];
    [self bindTableViewCommands];
    
    // 使用ViewModel的Command来加载数据，而非直接调用
    [self.viewModel.loadDataCommand execute:nil];
    
    //FPS label
    [self addFPSLabel];
}
- (void)configUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 给tableview的models绑定一个监听信号
    RAC(self.tableView, models) = RACObserve(self.viewModel, models);
    RAC(self.tableView, sectionHeaderModels) = RACObserve(self.viewModel, sectionHeaderModels);
    RAC(self.tableView, sectionFooterModels) = RACObserve(self.viewModel, sectionFooterModels);
}

#pragma mark - ViewModel Bindings
- (void)setupViewModelBindings {
    @weakify(self);
    
    // 绑定加载状态
    [self.viewModel.loadingStateSignal subscribeNext:^(NSNumber *loading) {
        @strongify(self);
        if (loading.boolValue) {
            NSLog(@"📱 [VC] 数据加载中...");
            // 可以在这里显示loading状态
        } else {
            NSLog(@"📱 [VC] 数据加载完成");
            // 隐藏loading状态
        }
    }];
    
    // 绑定错误处理
    [self.viewModel.errorSignal subscribeNext:^(NSError *error) {
        @strongify(self);
        NSLog(@"❌ [VC] 错误: %@", error.localizedDescription);
        // 可以在这里显示错误提示
    }];
}

- (void)bindTableViewCommands {
    // 使用ViewModel的Command替代VC中直接创建Command
    self.tableView.didSelectCommand = self.viewModel.cellDidSelectCommand;
}
#pragma mark - test case
-(void)dzwCell_alphaAction:(NSDictionary *)userinfo{
    NSLog(@"alpha------------- %@",userinfo);
}
-(void)dzwCell_betaAction:(NSDictionary *)userinfo{
    NSLog(@"beta------------- %@",userinfo);
}
-(void)dzwCell_gamaAction:(NSDictionary *)userinfo{
    NSLog(@"gama------------- %@",userinfo);
}

#pragma mark - RACTableViewDelegate  
/// 第三轮优化：进一步简化，统一使用配置方法
- (void)rac_tableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 统一的Cell配置方法，更清晰
    [self configureCellCommands:cell atIndexPath:indexPath];
}

/// 统一配置Cell的Commands
- (void)configureCellCommands:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    
    if ([cell isKindOfClass:[DzwTestTabCell class]]) {
        [self configureBasicCell:(DzwTestTabCell *)cell atIndexPath:indexPath];
        
    } else if ([cell isKindOfClass:[DzwTestTabCell_3 class]]) {
        [self configureFoldableCell:(DzwTestTabCell_3 *)cell atIndexPath:indexPath];
        
    } else if ([cell isKindOfClass:[DzwTestTabCell_4 class]]) {
        [self configureTextInputCell:(DzwTestTabCell_4 *)cell atIndexPath:indexPath];
    }
}

/// 配置基础Cell
- (void)configureBasicCell:(DzwTestTabCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    
    // Cell已经有自己的CellViewModel处理业务逻辑，这里只需要简单的事件传递
    cell.tapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        // 可选：向主ViewModel通知Cell按钮被点击
        return [self.viewModel.cellButtonTapCommand execute:RACTuplePack(indexPath, input)];
    }];
    
    cell.tapSubject = [RACSubject subject];
    [cell.tapSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.cellButtonTapCommand execute:RACTuplePack(indexPath, x)];
    }];
}

/// 配置可折叠Cell
- (void)configureFoldableCell:(DzwTestTabCell_3 *)cell atIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    
    // 折叠Cell的业务逻辑已经在其CellViewModel中，这里只处理UI刷新
    cell.foldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        // 主要职责：UI刷新
        [self.tableView d_reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
        
        // 可选：通知主ViewModel
        [self.viewModel.cellFoldCommand execute:RACTuplePack(indexPath, input)];
        
        return [RACSignal empty];
    }];
}

/// 配置文本输入Cell  
- (void)configureTextInputCell:(DzwTestTabCell_4 *)cell atIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    
    cell.textViewChanegdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        // 主要职责：UI高度调整
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        // 可选：通知主ViewModel处理文本变化
        [self.viewModel.textViewChangedCommand execute:input];
        
        return [RACSignal empty];
    }];
}

#pragma mark - getter & setter
- (DRacTableView *)tableView{
    if(!_tableView){
        _tableView = [[DRacTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rac_delegate = self;
    }
    return _tableView;
}

- (DzwTestTabVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[DzwTestTabVM alloc]init];
    }
    return _viewModel;
}

-(void)addFPSLabel{
    //FPS label
    YYFPSLabel *fpsLabel = [YYFPSLabel new];
    fpsLabel.frame = CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-110, 60, 30);
    [self.view addSubview:fpsLabel];
}
@end
