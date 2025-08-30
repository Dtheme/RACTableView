//
//  DzwTestTabVM.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface DzwTestTabVM : NSObject

#pragma mark - 数据源 (Data Source)
@property (nonatomic, copy, readonly) NSArray *models;
@property (nonatomic, copy, readonly) NSArray *sectionHeaderModels;
@property (nonatomic, copy, readonly) NSArray *sectionFooterModels;

#pragma mark - 状态管理 (State Management)
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign, readonly) BOOL hasMoreData;
@property (nonatomic, strong, readonly) NSError *error;

#pragma mark - 用户交互Commands (User Interaction Commands)
/// 初始加载数据
@property (nonatomic, strong, readonly) RACCommand *loadDataCommand;
/// 上拉加载更多
@property (nonatomic, strong, readonly) RACCommand *loadMoreCommand;
/// 刷新数据
@property (nonatomic, strong, readonly) RACCommand *refreshCommand;

#pragma mark - Cell交互Commands (Cell Interaction Commands)  
/// Cell点击事件
@property (nonatomic, strong, readonly) RACCommand *cellDidSelectCommand;
/// Cell内按钮点击事件
@property (nonatomic, strong, readonly) RACCommand *cellButtonTapCommand;
/// Cell收起/展开事件
@property (nonatomic, strong, readonly) RACCommand *cellFoldCommand;
/// TextView内容变化事件
@property (nonatomic, strong, readonly) RACCommand *textViewChangedCommand;

#pragma mark - 响应式信号 (Reactive Signals)
/// 数据加载状态信号
@property (nonatomic, strong, readonly) RACSignal *loadingStateSignal;
/// 错误处理信号
@property (nonatomic, strong, readonly) RACSignal *errorSignal;

#pragma mark - Public Methods
- (instancetype)init;
- (void)setupCommands;

@end

NS_ASSUME_NONNULL_END
