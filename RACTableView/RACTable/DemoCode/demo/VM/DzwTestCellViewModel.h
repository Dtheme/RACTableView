//
//  DzwTestCellViewModel.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@class DzwTestTabModel, DzwTestTabModel2;

/// Cell级别的ViewModel，处理单个Cell的业务逻辑
@interface DzwTestCellViewModel : NSObject

#pragma mark - Properties
@property (nonatomic, strong, readonly) id<RACModelDelegate> cellModel;
@property (nonatomic, assign, readonly) BOOL isFolded;
@property (nonatomic, assign, readonly) CGFloat calculatedHeight;

#pragma mark - Commands
/// 切换折叠状态Command
@property (nonatomic, strong, readonly) RACCommand *toggleFoldCommand;
/// 按钮点击Command
@property (nonatomic, strong, readonly) RACCommand *buttonTapCommand;
/// 文本变化Command
@property (nonatomic, strong, readonly) RACCommand *textChangeCommand;

#pragma mark - Signals
/// 折叠状态变化信号
@property (nonatomic, strong, readonly) RACSignal *foldStateSignal;
/// 高度变化信号
@property (nonatomic, strong, readonly) RACSignal *heightChangedSignal;

#pragma mark - Initialization
- (instancetype)initWithCellModel:(id<RACModelDelegate>)cellModel;

@end

NS_ASSUME_NONNULL_END
