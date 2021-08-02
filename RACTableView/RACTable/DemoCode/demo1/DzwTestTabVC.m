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

@interface DzwTestTabVC ()<ZGRacTableViewDelegate>
@property (nonatomic, strong) ZGRacTableView *tableView;
@property (nonatomic, strong) DzwTestTabVM *viewModel;
@end

@implementation DzwTestTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel loadData];
    [self excuteTableviewCommands];
    
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

- (void)excuteTableviewCommands{
    @weakify(self);
    //点击cell事件
    self.tableView.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(RACThreeTuple<UITableView *, NSIndexPath *, id>* _Nullable input) {
        @strongify(self);
        NSLog(@"%@",input);
        //点击所在tableview
        UITableView *tableview = input.first;
        
        //点击的indexPath
        NSIndexPath *indexPath = input.second;
        
        //点击所在index的数据源model
        DzwTestTabModel *md = input.third;
        
        NSLog(@"🌗🌗[RACCommand]点击了cell 序列号是：%ld-%ld ,cell文本：%@",indexPath.section,indexPath.row,md.titleString);
    
        return [RACSignal empty];
    }];
}

#pragma mark - ZGRacTableViewDelegate
//获取cell中回调出来的事件
- (void)rac_ableView:(UITableView *)tableView cell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[DzwTestTabCell class]]) {
        DzwTestTabCell * testCell = (DzwTestTabCell *)cell;
        //cell上按钮的点击事件
        testCell.tapCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSLog(@"🌗🌗[RACCommand]点击了cell上的按钮 序列号是：%ld-%ld",(long)indexPath.section,(long)indexPath.row);
            return [RACSignal empty];
        }];
        
        testCell.tapSubject = [RACSubject subject];
        [testCell.tapSubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"🌗🌗[RACSubject]点击了cell上的按钮 序列号是：%ld-%ld",(long)indexPath.section,(long)indexPath.row);
        }];
        
    }else if ([cell isKindOfClass:[DzwTestTabCell_3 class]]){
        DzwTestTabCell_3 *testcell3 = (DzwTestTabCell_3 *)cell;
        @weakify(self);
        testcell3.foldCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id _Nullable input) {
            @strongify(self);
            NSLog(@"🌗🌗展开收起cell的 序列号是：%ld-%ld",(long)indexPath.section,(long)indexPath.row);
            [self.tableView zg_reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            return [RACSignal empty];
        }];
    }else if ([cell isKindOfClass:[DzwTestTabCell_4 class]]){
        DzwTestTabCell_4 *testcell4 = (DzwTestTabCell_4 *)cell;
        testcell4.textViewChanegdCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSLog(@"textview输入：%@",input);
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            return [RACSignal empty];
        }];
    }
}

#pragma mark - getter & setter
- (ZGRacTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZGRacTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
