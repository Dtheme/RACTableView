//
//  DRacTableView.m
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DRacTableView.h"
#import "DzwRACProxy.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface DRacTableView ()
@property (nonatomic, strong) DzwRACProxy *delegateProxy;
@property (nonatomic, strong) DzwRACProxy *dataSourceProxy;
@end

@implementation DRacTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self binding];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self binding];
    }
    return self;
}

- (void)binding {
    [super setDelegate:(id<UITableViewDelegate>)self.delegateProxy];
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceProxy];
    self.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {

    }else{
        self.estimatedRowHeight = kScale_W(44);
    }
    @weakify(self);
    [[RACObserve(self, models) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id obj = self.models[section];
    if ([obj isKindOfClass:[NSArray class]]) {
        return [obj count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<RACModelDelegate> *cellModel = [self cellModelAtIndexPath:indexPath];
    UITableViewCell *cell;
    if (cellModel.cellClass) {
        cell = [cellModel.cellClass cellForTableView:tableView cellModel:cellModel];
    }else if(cellModel.cellNib){
        cell = [cellModel.cellNib cellForTableView:tableView cellModel:cellModel];
    }
    if (_rac_delegate && [_rac_delegate respondsToSelector:@selector(rac_tableView:cell:cellForRowAtIndexPath:)]) {
        [_rac_delegate rac_tableView:tableView cell:cell cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<RACModelDelegate> *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel.cellHeight.doubleValue == 0) {
        CGFloat cellH = [tableView fd_heightForCellWithIdentifier:cellModel.cellReuseIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
            
        }];
        return cellH;
//        return UITableViewAutomaticDimension;
    }else if ([cellModel.cellHeight doubleValue] == UITableViewAutomaticDimension){
        return UITableViewAutomaticDimension;
    } else{
        return cellModel.cellHeight.doubleValue;
    } 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<RACModelDelegate> *cellModel = [self cellModelAtIndexPath:indexPath];
    [self.didSelectCommand execute:RACTuplePack(tableView, indexPath, cellModel)];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSObject<RACModelDelegate> *sectionMd = [self sectionHeaderViewModelInSection:section];
    UIView *header = [sectionMd.sectionHeaderClass tableView:tableView viewforSection:section sectionViewModel:sectionMd];
    if (header) {
        if (_rac_delegate && [_rac_delegate respondsToSelector:@selector(rac_tableView:headerView:viewForHeaderInSection:)]) {
            [_rac_delegate rac_tableView:tableView headerView:header viewForHeaderInSection:section];
        }
    }
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSObject<RACModelDelegate> *sectionMd = [self sectionFooterViewModelInSection:section];
    UIView *footer = [sectionMd.sectionFooterClass tableView:tableView viewforSection:section sectionViewModel:sectionMd];
    if (footer) {
        if (_rac_delegate && [_rac_delegate respondsToSelector:@selector(rac_tableView:headerView:viewForHeaderInSection:)]) {
            [_rac_delegate rac_tableView:tableView headerView:footer viewForHeaderInSection:section];
        }
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSObject<RACModelDelegate> *cellModel = [self sectionHeaderViewModelInSection:section];
    return [cellModel.sectionHeaderHeight doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSObject<RACModelDelegate> *cellModel = [self sectionFooterViewModelInSection:section];
    return [cellModel.sectionFooterHeight floatValue];
}
#pragma mark - Private
- (NSObject<RACModelDelegate> *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.models[indexPath.section];
    if ([obj isKindOfClass:[NSArray class]]) {
        return [obj objectAtIndex:indexPath.row];
    } else {
        return obj;
    }
}
-(NSObject<RACModelDelegate> *)sectionHeaderViewModelInSection:(NSInteger)section{
    if (section<self.sectionHeaderModels.count) {
        id obj = self.sectionHeaderModels[section];
        return obj;
    }else{
        return nil;
    }
}
-(NSObject<RACModelDelegate> *)sectionFooterViewModelInSection:(NSInteger)section{
    if (section<self.sectionFooterModels.count) {
        id obj = self.sectionFooterModels[section];
        return obj;
    }else{
        return nil;
    }
}
#pragma mark - Getter && Setter
- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.delegateProxy.middleman = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.delegateProxy];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.dataSourceProxy.middleman = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceProxy];
}

- (DzwRACProxy *)delegateProxy {
    if (!_delegateProxy) {
        _delegateProxy = [[DzwRACProxy alloc] init];
        _delegateProxy.receiver = self;
    }
    return _delegateProxy;
}

- (DzwRACProxy *)dataSourceProxy {
    if (!_dataSourceProxy) {
        _dataSourceProxy = [[DzwRACProxy alloc] init];
        _dataSourceProxy.receiver = self;
    }
    return _dataSourceProxy;
}

@end
