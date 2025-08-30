//
//  DzwTestTabCell_3.h
//  RACTable
//
//  Created by dzw on 2021/1/21.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DzwTestCellViewModel;

@interface DzwTestTabCell_3 : UITableViewCell

/// ✅ 使用CellViewModel管理业务逻辑
@property (nonatomic, strong) DzwTestCellViewModel *cellViewModel;

/// 向上传递折叠事件的Command（可选，用于通知上层）
@property (nonatomic, strong) RACCommand *foldCommand;

@end

NS_ASSUME_NONNULL_END
