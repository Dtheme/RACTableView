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
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel2 * _Nullable model) {
        @strongify(self);
        self.subTable_dataSource = [NSArray arrayWithArray:model.subCellData];
        [self.topButton setTitle:[NSString stringWithFormat:@"cell内嵌tableview:%@",self.cellModel.isfold?@"收起":@"展开"] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }];
    // 给tableview的models绑定一个监听信号
    RAC(self.tableView,models) = RACObserve(self, subTable_dataSource);
}

- (void)foldAndExpandAction:(UIButton *)sender{
    self.cellModel.isfold = !self.cellModel.isfold;
    CGFloat cellHeight = 0;
    for (DzwTestTabModel *md in self.subTable_dataSource) {
        md.isfold = !md.isfold;
        cellHeight += [md.cellHeight floatValue];
    }
    if (self.cellModel.isfold) {
        self.cellModel.cellHeight = @(kScale_W(54));
    }else{
        self.cellModel.cellHeight = @(cellHeight+kScale_W(44));
    }
    //回调点击事件
    if (self.foldCommand) {
        [self.foldCommand execute:@(self.cellModel.isfold)];
    }
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
