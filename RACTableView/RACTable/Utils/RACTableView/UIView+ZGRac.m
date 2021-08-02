//
//  UIView+ZGRac.m
//  RACTable
//
//  Created by dzw on 2021/1/5.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "UIView+ZGRac.h"
#import <objc/message.h>
#import <Masonry.h>
@implementation UIView (ZGRac)
+ (void)load {
    Method original = class_getInstanceMethod(self.class, @selector(initWithFrame:));
    Method swizzled = class_getInstanceMethod(self.class, @selector(zg_initWithFrame:));
    method_exchangeImplementations(original, swizzled);
}

- (instancetype)zg_initWithFrame:(CGRect)frame {
    UIView *header = [self zg_initWithFrame:frame];
    [header sectionViewDidLoad];
    return header;
}

#pragma mark - ZGRacModelDelegate
+ (CGFloat)heightForSectionViewModel:(id<ZGRacModelDelegate>)sectionViewModel{
    return 0;
}
+ (instancetype)tableView:(UITableView *)tableView viewforSection:(NSInteger)section sectionViewModel:(id<ZGRacModelDelegate>)sectionViewModel{
    UIView *view = [[self alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0)];
    view.sectionViewModel = sectionViewModel;
    return view;
}
- (void)sectionViewDidLoad {}

#pragma mark - Getter & Setter
- (void)setSectionViewModel:(id<ZGRacModelDelegate>)sectionViewModel {
    objc_setAssociatedObject(self, @selector(sectionViewModel), sectionViewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<ZGRacModelDelegate>)sectionViewModel {
    return objc_getAssociatedObject(self, _cmd);
}
@end
