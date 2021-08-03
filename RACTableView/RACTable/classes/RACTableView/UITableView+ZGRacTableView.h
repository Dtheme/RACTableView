//
//  UITableView+ZGTableView.h
//  RACTable
//
//  Created by dzw on 2019/6/19.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZGRacTableView)
/** 带begin end 的刷新 */
- (void)zg_updateWithBlock:(void (^)(UITableView *tableView))block;
/** 代码滚动tableview */
- (void)zg_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
/** 根据indexPath刷新 */
- (void)zg_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
/** 刷新某个cell */
- (void)zg_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
/** 刷新整个section */
- (void)zg_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
