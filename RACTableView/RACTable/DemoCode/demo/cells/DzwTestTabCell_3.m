//
//  DzwTestTabCell_3.m
//  RACTable
//
//  Created by dzw on 2021/1/21.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabCell_3.h"
#import "DzwTestTabModel2.h"
#import "DzwTestTabModel.h"
#import "DzwTestSubCell.h"
#import "DzwTestCellViewModel.h"

@interface DzwTestTabCell_3()<UITableViewDelegate>
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) DRacTableView *tableView;
/** 内嵌tableview的数据源*/
@property (nonatomic, strong) NSArray *subTable_dataSource;
@end

@implementation DzwTestTabCell_3

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //标题
    [self.contentView addSubview:self.topButton];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScale_W(20));
        make.right.mas_equalTo(-kScale_W(20));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kScale_W(44));
    }];
    //tableView
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topButton.mas_bottom);
        make.bottom.mas_equalTo(-kScale_W(10));
    }];
}
//+ (CGFloat)cellHeightForCellModel:(id<RACModelDelegate>)cellModel{
//    return [cellModel.cellHeight floatValue];
//}
- (void)bindingCellData{
    @weakify(self);
    
    // ✅ 当cellModel变化时，创建对应的CellViewModel
    [[RACObserve(self, cellModel) skip:1] subscribeNext:^(DzwTestTabModel2 * _Nullable model) {
        @strongify(self);
        
        // 创建CellViewModel来处理业务逻辑
        self.cellViewModel = [[DzwTestCellViewModel alloc] initWithCellModel:model];
        
        // 设置数据源
        self.subTable_dataSource = [NSArray arrayWithArray:model.subCellData];
        [self.tableView reloadData];
        
        // 绑定折叠状态到UI
        [self bindFoldState];
        [self bindHeightChanges];
    }];
    
    // 给tableview的models绑定一个监听信号
    RAC(self.tableView,models) = RACObserve(self, subTable_dataSource);
}

/// 绑定折叠状态变化到UI显示
- (void)bindFoldState {
    @weakify(self);
    [self.cellViewModel.foldStateSignal subscribeNext:^(NSNumber *isFolded) {
        @strongify(self);
        NSString *title = [NSString stringWithFormat:@"cell内嵌tableview:%@", 
                          isFolded.boolValue ? @"收起" : @"展开"];
        [self.topButton setTitle:title forState:UIControlStateNormal];
    }];
}

/// 绑定高度变化
- (void)bindHeightChanges {
    @weakify(self);
    [self.cellViewModel.heightChangedSignal subscribeNext:^(NSNumber *height) {
        @strongify(self);
        // 高度变化时可能需要通知外层刷新
        NSLog(@"📱 [Cell] 高度变化为: %.2f", height.floatValue);
    }];
}

- (void)foldAndExpandAction:(UIButton *)sender{
    @weakify(self);
    
    // ✅ 重构后：只负责调用CellViewModel的Command，不处理业务逻辑
    [[self.cellViewModel.toggleFoldCommand execute:nil] subscribeNext:^(NSNumber *isFolded) {
        @strongify(self);
        
        // 向上传递折叠事件（如果外层需要知道）
        if (self.foldCommand) {
            [self.foldCommand execute:isFolded];
        }
        
        NSLog(@"📱 [Cell] 折叠状态已更新为: %@", isFolded.boolValue ? @"折叠" : @"展开");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (UIButton *)topButton{
    if(!_topButton){
        _topButton = [[UIButton alloc]init];
        [_topButton setTitleColor:HexColor(@"#5E6BFE") forState:UIControlStateNormal];
        [_topButton setTitle:@"cell内嵌tableview" forState:UIControlStateNormal];
        _topButton.titleLabel.font = kFontWithName(kMedFont, 13.f);
        _topButton.layer.cornerRadius = 5;
        _topButton.backgroundColor = [HexColor(@"#5E6BFE") colorWithAlphaComponent:0.3];
        _topButton.layer.borderColor = HexColor(@"#5E6BFE").CGColor;
        _topButton.layer.borderWidth = 0.5;
        _topButton.layer.masksToBounds = YES;
        [_topButton addTarget:self action:@selector(foldAndExpandAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DzwTestTabModel *md = self.subTable_dataSource[indexPath.row];
    return md.isfold?0:[md.cellHeight floatValue];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
 
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    return @[deleteAction];
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}
#pragma mark - getter/setter
- (DRacTableView *)tableView{
    if(!_tableView){
        _tableView = [[DRacTableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.estimatedRowHeight = kScale_W(200);
    }
    return _tableView;
}

@end
