//
//  NSObject+ZGRac.m
//  RACTable
//
//  Created by dzw on 2021/2/4.
//  Copyright © 2021 ZEGO. All rights reserved.
//

#import "NSObject+ZGRac.h"
#import <objc/message.h>
@implementation NSObject (ZGRac)

- (void)setCellNib:(Class)cellNib {
    objc_setAssociatedObject(self, @selector(cellNib), NSStringFromClass(cellNib), OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSString *cellReuseIdentifier = [self cellReuseIdentifier];
    cellReuseIdentifier = kISNullString(cellReuseIdentifier)?NSStringFromClass(cellNib):cellReuseIdentifier;
#warning 测试代码
#ifdef DEBUG
    NSLog(@"NSObject (ZGRac)[cellNib]  identifier---：%@",cellReuseIdentifier);
#endif
    [self setCellReuseIdentifier:cellReuseIdentifier];
}

- (Class)cellNib {
    return NSClassFromString(objc_getAssociatedObject(self, _cmd));
}

- (void)setCellClass:(Class)cellClass {
    objc_setAssociatedObject(self, @selector(cellClass), NSStringFromClass(cellClass), OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSString *cellReuseIdentifier = [self cellReuseIdentifier];
    cellReuseIdentifier = kISNullString(cellReuseIdentifier)?NSStringFromClass(cellClass):cellReuseIdentifier;
#warning 测试代码
#ifdef DEBUG
    NSLog(@"NSObject (ZGRac)[cellClass]  identifier---：%@",cellReuseIdentifier);
#endif
    [self setCellReuseIdentifier:cellReuseIdentifier];
}

- (Class)cellClass {
    return NSClassFromString(objc_getAssociatedObject(self, _cmd));
}

- (void)setCellHeight:(NSNumber *)cellHeight {
    objc_setAssociatedObject(self, @selector(cellHeight), cellHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)cellHeight {
    NSNumber *cellHeight = objc_getAssociatedObject(self, _cmd);
    if (!cellHeight) {
        cellHeight = @([self.cellClass cellHeightForCellModel:(id<ZGRacModelDelegate>)self]);
        self.cellHeight = cellHeight;
    }
    return cellHeight;
}

- (NSString *)cellReuseIdentifier{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCellReuseIdentifier:(NSString *)cellReuseIdentifier{
    objc_setAssociatedObject(self, @selector(cellReuseIdentifier), cellReuseIdentifier, OBJC_ASSOCIATION_COPY);
}

- (void)setSectionHeaderClass:(Class)sectionHeaderClass {
    objc_setAssociatedObject(self, @selector(sectionHeaderClass), NSStringFromClass(sectionHeaderClass), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (Class)sectionHeaderClass {
    return NSClassFromString(objc_getAssociatedObject(self, _cmd));
}

- (void)setSectionHeaderHeight:(NSNumber *)sectionHeaderHeight {
    objc_setAssociatedObject(self, @selector(sectionHeaderHeight), sectionHeaderHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)sectionHeaderHeight {
    NSNumber *cellHeight = objc_getAssociatedObject(self, _cmd);
    if (!cellHeight) {
        cellHeight = @([self.cellClass cellHeightForCellModel:(id<ZGRacModelDelegate>)self]);
        self.cellHeight = cellHeight;
    }
    return cellHeight;
}

- (void)setSectionFooterClass:(Class)sectionFooterClass {
    objc_setAssociatedObject(self, @selector(sectionFooterClass), NSStringFromClass(sectionFooterClass), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (Class)sectionFooterClass {
    return NSClassFromString(objc_getAssociatedObject(self, _cmd));
}


- (void)setSectionFooterHeight:(NSNumber *)sectionFooterHeight {
    objc_setAssociatedObject(self, @selector(sectionFooterHeight), sectionFooterHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)sectionFooterHeight {
    NSNumber *cellHeight = objc_getAssociatedObject(self, _cmd);
    if (!cellHeight) {
        cellHeight = @([self.cellClass cellHeightForCellModel:(id<ZGRacModelDelegate>)self]);
        self.cellHeight = cellHeight;
    }
    return cellHeight;
}

-(void)mutableArray:(SEL)arrProperty addObject:(id)obj{
    [[self mutableArrayValueForKey:NSStringFromSelector(arrProperty)] addObject:obj];
}

@end
