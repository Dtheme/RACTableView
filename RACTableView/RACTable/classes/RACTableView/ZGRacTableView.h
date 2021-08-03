//
//  ZGRacTableView.h
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSObject+ZGRac.h"
#import "UITableViewCell+ZGRac.h"

/** cell缓存模式定义
    1.
 */
UIKIT_EXTERN NSExceptionName const ZGRacTableViewCellHeightCache_;
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

@interface ZGRacTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
/** tableview数据源
 1.如果只要一个section vm数据直接放到数据源里
    eg：models = @[@"cellModel1",@"cellModel2",@"cellModel3"];
 2.如果是要构建一个多section的tableview，将models构造成一个vm组成的二元数组即可
    eg：models = @[
                    @[@"cellModel1",@"cellModel2",@"cellModel3"], //section 1
                    @[@"cellModel1",@"cellModel2",@"cellModel3"], //section 2
                    @[@"cellModel1",@"cellModel2",@"cellModel3"]  //section 3
                ];
 3.sectionHeaderModels和sectionFooterModels是头尾view的数据源 只能是一元数组
 sectionHeaderModels = @[@"headerModel1",@"headerModel2",@"headerModel3"];
 */
@property (nonatomic, copy) NSArray *models;
@property (nonatomic, copy) NSArray *sectionHeaderModels;
@property (nonatomic, copy) NSArray *sectionFooterModels;

/**cell点击事件
 携带的参数分别是：
 1.UITableView *tableview;
 2.NSIndexPath *indexPath;
 3.id cellModel;
 */
@property (nonatomic, strong) RACCommand *didSelectCommand;

/**ZGRacTableViewDelegate代理*/
@property (nonatomic, weak) id <ZGRacTableViewDelegate> rac_delegate;

@end
