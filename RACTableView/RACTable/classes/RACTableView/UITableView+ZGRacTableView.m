//
//  UITableView+ZGTableView.m
//  RACTable
//
//  Created by dzw on 2019/6/19.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "UITableView+ZGRacTableView.h"

@implementation UITableView (ZGTableView)
- (void)zg_updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}

- (void)zg_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)zg_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)zg_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toReload = [NSIndexPath indexPathForRow:row inSection:section];
    [self zg_reloadRowAtIndexPath:toReload withRowAnimation:animation];
}

- (void)zg_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}
@end
