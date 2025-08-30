//
//  DzwTestCellViewModel.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestCellViewModel.h"
#import "DzwTestTabModel.h"
#import "DzwTestTabModel2.h"

@interface DzwTestCellViewModel ()

@property (nonatomic, strong, readwrite) id<RACModelDelegate> cellModel;
@property (nonatomic, assign, readwrite) BOOL isFolded;
@property (nonatomic, assign, readwrite) CGFloat calculatedHeight;

@property (nonatomic, strong, readwrite) RACCommand *toggleFoldCommand;
@property (nonatomic, strong, readwrite) RACCommand *buttonTapCommand;
@property (nonatomic, strong, readwrite) RACCommand *textChangeCommand;

@property (nonatomic, strong, readwrite) RACSignal *foldStateSignal;
@property (nonatomic, strong, readwrite) RACSignal *heightChangedSignal;

@end

@implementation DzwTestCellViewModel

#pragma mark - Initialization
- (instancetype)initWithCellModel:(id<RACModelDelegate>)cellModel {
    if (self = [super init]) {
        self.cellModel = cellModel;
        [self setupInitialState];
        [self setupCommands];
        [self setupSignals];
    }
    return self;
}

#pragma mark - Setup Methods
- (void)setupInitialState {
    // 从Model中读取初始状态
    if ([self.cellModel respondsToSelector:@selector(isfold)]) {
        self.isFolded = [(DzwTestTabModel *)self.cellModel isfold];
    } else {
        self.isFolded = NO;
    }
    
    // 计算初始高度
    [self calculateHeight];
}

- (void)setupCommands {
    @weakify(self);
    
    // 折叠切换Command
    self.toggleFoldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self executeToggleFold];
    }];
    
    // 按钮点击Command
    self.buttonTapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self executeButtonTap:input];
    }];
    
    // 文本变化Command
    self.textChangeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *text) {
        @strongify(self);
        return [self executeTextChange:text];
    }];
}

- (void)setupSignals {
    // 折叠状态变化信号
    self.foldStateSignal = RACObserve(self, isFolded);
    
    // 高度变化信号
    self.heightChangedSignal = RACObserve(self, calculatedHeight);
}

#pragma mark - Command Execution
- (RACSignal *)executeToggleFold {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 切换状态
        self.isFolded = !self.isFolded;
        
        // 更新Model状态
        if ([self.cellModel respondsToSelector:@selector(setIsfold:)]) {
            [(DzwTestTabModel *)self.cellModel setIsfold:self.isFolded];
        }
        
        // 处理子项目的折叠状态（针对嵌套TableView的情况）
        if ([self.cellModel isKindOfClass:[DzwTestTabModel2 class]]) {
            [self handleSubItemsFold];
        }
        
        // 重新计算高度
        [self calculateHeight];
        
        NSLog(@"📱 [CellVM] 折叠状态切换为: %@", self.isFolded ? @"折叠" : @"展开");
        
        [subscriber sendNext:@(self.isFolded)];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)executeButtonTap:(id)input {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"📱 [CellVM] 按钮被点击: %@", input);
        
        // 可以在这里添加具体的按钮处理逻辑
        // 比如收藏、点赞、分享等操作
        
        [subscriber sendNext:input];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)executeTextChange:(NSString *)text {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"📱 [CellVM] 文本内容变化: %@", text);
        
        // 文本变化后重新计算高度
        [self calculateHeightForText:text];
        
        [subscriber sendNext:text];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - Business Logic
- (void)handleSubItemsFold {
    if ([self.cellModel isKindOfClass:[DzwTestTabModel2 class]]) {
        DzwTestTabModel2 *model2 = (DzwTestTabModel2 *)self.cellModel;
        
        // 处理嵌套子项的折叠状态
        for (DzwTestTabModel *subModel in model2.subCellData) {
            subModel.isfold = self.isFolded;
        }
    }
}

- (void)calculateHeight {
    CGFloat height = 0;
    
    if ([self.cellModel isKindOfClass:[DzwTestTabModel2 class]]) {
        DzwTestTabModel2 *model2 = (DzwTestTabModel2 *)self.cellModel;
        
        if (self.isFolded) {
            height = kScale_W(54); // 折叠状态的高度
        } else {
            // 展开状态：计算所有子项的高度
            for (DzwTestTabModel *subModel in model2.subCellData) {
                height += [subModel.cellHeight floatValue];
            }
            height += kScale_W(44); // 加上标题栏高度
        }
        
        // 更新Model的高度
        self.cellModel.cellHeight = @(height);
    } else {
        // 其他类型的Cell使用默认高度
        height = [self.cellModel.cellHeight floatValue];
    }
    
    self.calculatedHeight = height;
}

- (void)calculateHeightForText:(NSString *)text {
    // 根据文本内容计算高度
    if (text.length > 0) {
        CGFloat textHeight = [DzwTool getRectByWidth:SCREEN_WIDTH-kScale_W(40) 
                                              string:text 
                                                font:kFontWithName(kMedFont, 13.f)].size.height;
        CGFloat totalHeight = textHeight + kScale_W(20); // 加上padding
        
        self.calculatedHeight = totalHeight;
        self.cellModel.cellHeight = @(totalHeight);
    }
}

@end
