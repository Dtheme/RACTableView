//
//  UITableViewCell+ZGRac.h
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 ZEGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGRacModelDelegate;
@protocol ZGRacTableViewCellDelegate <NSObject>

/**
 计算 Cell 高度，默认为 0，会被 CellModel 缓存
 调用方式为 - [cellModel cellHeight]，建议提前调用缓存高度

 @param cellModel cellModel
 @return cellHeight
 */
+ (CGFloat)cellHeightForCellModel:(id<ZGRacModelDelegate>)cellModel;

/**
 cell 创建完成会回调这个方法
 监听模型变化 绑定cell数据源
 */
- (void)bindingCellData;


/**
 注册 Cell（ 非必要实现 ）
 默认调用 registerClass:forCellReuseIdentifier:
 使用 xib 或需要手动注册的需要实现该方法
 
 @param tableView tableView
 @param identify identify
 */
+ (void)registerCellWithTableView:(UITableView *)tableView identify:(NSString *)identify;


/**
 数据源方法
 ❗️如果使用这个tableview封装，如果非必要，不要主动实现该方法，这是内部用的方法，请在重写 setCellModel: 设置 Cell

 @param tableView tableView
 @param cellModel cellModel
 @return cell
 */
+ (instancetype)cellForTableView:(UITableView *)tableView cellModel:(id<ZGRacModelDelegate>)cellModel;


@end

@interface UITableViewCell (ZGRacCell) <ZGRacTableViewCellDelegate>

@property (nonatomic, strong) id<ZGRacModelDelegate> cellModel;
@end
