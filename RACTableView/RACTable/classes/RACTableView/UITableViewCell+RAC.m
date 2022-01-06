//
//  UITableViewCell+RAC.m
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "UITableViewCell+RAC.h"
#import <objc/message.h>

@implementation UITableViewCell (RAC)

+ (void)load {
    Method cell_style_original = class_getInstanceMethod(self.class, @selector(initWithStyle:reuseIdentifier:));
    Method cell_style_swizzled = class_getInstanceMethod(self.class, @selector(d_initWithStyle:reuseIdentifier:));
    
    Method init_coder_original = class_getInstanceMethod(self.class, @selector(initWithCoder:));
    Method init_coder_swizzled = class_getInstanceMethod(self.class, @selector(d_initWithCoder:));
    method_exchangeImplementations(cell_style_original, cell_style_swizzled);
    method_exchangeImplementations(init_coder_original, init_coder_swizzled);
}

- (instancetype)d_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = [self d_initWithStyle:style reuseIdentifier:reuseIdentifier];
    [cell bindingCellData];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (instancetype)d_initWithCoder:(NSCoder *)coder{
    UITableViewCell *cell = [self d_initWithCoder:coder];
    [cell bindingCellData];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - RACModelDelegate
+ (void)registerCellWithTableView:(UITableView *)tableView identify:(NSString *)identify {
    [tableView registerClass:self forCellReuseIdentifier:identify];
}

+ (void)registerCellNibWithTableView:(UITableView *)tableView identify:(NSString *)identify {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identify];
}

+ (instancetype)cellForTableView:(UITableView *)tableView cellModel:(id<RACModelDelegate>)cellModel {
    NSString *identify = NSStringFromClass(self.class);
    NSString *cellID = kISNullString(cellModel.cellReuseIdentifier)?identify:cellModel.cellReuseIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.cellModel.cellReuseIdentifier = cellID;
    if (!cell) {
        if (cellModel.cellClass) {
            [self registerCellWithTableView:tableView identify:cellID];
        }
        
        if (cellModel.cellNib) {
            [self registerCellNibWithTableView:tableView identify:cellID];
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    cell.cellModel = cellModel;
    return cell;
}

+ (CGFloat)cellHeightForCellModel:(id<RACModelDelegate>)cellModel {
    return 0;
}

- (void)bindingCellData {
}

#pragma mark - Getter & Setter
- (void)setCellModel:(id<RACModelDelegate>)cellModel {
    objc_setAssociatedObject(self, @selector(cellModel), cellModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<RACModelDelegate>)cellModel {
    return objc_getAssociatedObject(self, _cmd);
}

@end
