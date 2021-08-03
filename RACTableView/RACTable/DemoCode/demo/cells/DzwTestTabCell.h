//
//  DzwTestTabCell.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DzwTestTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UITextView *inputView;

//按钮点击事件
@property (nonatomic, strong) RACCommand *tapCommand;
@property (nonatomic, strong) RACSubject *tapSubject;
//textview内容改变
@property (nonatomic, strong) RACCommand *textChangeCommand;
@end

NS_ASSUME_NONNULL_END
