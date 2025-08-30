//
//  DzwTestTabCell.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DzwTestCellViewModel;

@interface DzwTestTabCell : UITableViewCell

#pragma mark - UI Elements
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UITextView *inputView;

#pragma mark - ViewModel
/// ✅ 使用CellViewModel管理业务逻辑
@property (nonatomic, strong) DzwTestCellViewModel *cellViewModel;

#pragma mark - Commands (向上传递事件用)
/// 按钮点击事件传递
@property (nonatomic, strong) RACCommand *tapCommand;
@property (nonatomic, strong) RACSubject *tapSubject;
/// textview内容改变事件传递
@property (nonatomic, strong) RACCommand *textChangeCommand;

@end

NS_ASSUME_NONNULL_END
