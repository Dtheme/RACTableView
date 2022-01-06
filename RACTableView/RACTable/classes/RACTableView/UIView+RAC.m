//
//  UIView+RAC.m
//  RACTable
//
//  Created by dzw on 2021/1/5.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "UIView+RAC.h"
#import <objc/message.h>
#import <Masonry.h>
@implementation UIView (RAC)
+ (void)load {
    Method original = class_getInstanceMethod(self.class, @selector(initWithFrame:));
    Method swizzled = class_getInstanceMethod(self.class, @selector(d_initWithFrame:));
    method_exchangeImplementations(original, swizzled);
}

- (instancetype)d_initWithFrame:(CGRect)frame {
    UIView *header = [self d_initWithFrame:frame];
    [header sectionViewDidLoad];
    return header;
}

#pragma mark - RACModelDelegate
+ (CGFloat)heightForSectionViewModel:(id<RACModelDelegate>)sectionViewModel{
    return 0;
}
+ (instancetype)tableView:(UITableView *)tableView viewforSection:(NSInteger)section sectionViewModel:(id<RACModelDelegate>)sectionViewModel{
    UIView *view = [[self alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0)];
    view.sectionViewModel = sectionViewModel;
    return view;
}
- (void)sectionViewDidLoad {}

#pragma mark - Getter & Setter
- (void)setSectionViewModel:(id<RACModelDelegate>)sectionViewModel {
    objc_setAssociatedObject(self, @selector(sectionViewModel), sectionViewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<RACModelDelegate>)sectionViewModel {
    return objc_getAssociatedObject(self, _cmd);
}
@end
