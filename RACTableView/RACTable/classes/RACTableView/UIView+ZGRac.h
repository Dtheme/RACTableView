//
//  UIView+ZGRac.h
//  RACTable
//
//  Created by dzw on 2021/1/5.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGRacModelDelegate;
@protocol ZGRacSectionViewDelegate <NSObject>

/**
 计算 Cell 高度，默认为 0，会被 sectionViewModel 缓存
 调用方式为 - [sectionViewModel sectionViewHeight]，建议提前调用缓存高度

 @param sectionViewModel sectionViewModel
 @return sectionViewHeight
 */
+ (CGFloat)heightForSectionViewModel:(id<ZGRacModelDelegate>)sectionViewModel;

/**
 sectionView 创建完成回调
 可以在这里进行model绑定、修改sectionView的细节样式等操作
 */
- (void)sectionViewDidLoad;

/**
 数据源方法
 不建议实现该方法，请在重写 setCellModel: 设置 Cell

 @param tableView tableView
 @param section section
 @param sectionViewModel sectionViewModel
 @return cell
 */
+ (instancetype)tableView:(UITableView *)tableView viewforSection:(NSInteger)section sectionViewModel:(id<ZGRacModelDelegate>)sectionViewModel;

@end

@interface UIView (ZGRac)<ZGRacSectionViewDelegate>
@property (nonatomic, strong) id<ZGRacModelDelegate> sectionViewModel;
@end


