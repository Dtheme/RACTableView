//
//  DzwTestTabCell.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabCell.h"
#import "DzwTestTabModel.h"
#import "DzwTestCellViewModel.h"

@implementation DzwTestTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+ (CGFloat)cellHeightForCellModel:(id<RACModelDelegate>)cellModel{
    return [cellModel.cellHeight floatValue];
}
- (void)bindingCellData{
    @weakify(self);
    
    // ✅ 当cellModel变化时，创建CellViewModel并绑定数据
    [[RACObserve(self, cellModel) skip:1] subscribeNext:^(DzwTestTabModel * _Nullable model) {
        @strongify(self);
        
        // 创建CellViewModel
        self.cellViewModel = [[DzwTestCellViewModel alloc] initWithCellModel:model];
        
        // 绑定UI数据 - Cell依然负责UI显示
        self.imageV.image = kGetImageNamed(model.imageUrl);
        self.titleLb.text = model.titleString;
        self.detailLb.text = model.detailString;
        
        // 绑定CellViewModel的状态变化（如果需要）
        [self bindViewModelStates];
    }];
}

/// 绑定ViewModel状态到UI
- (void)bindViewModelStates {
    // 这里可以绑定CellViewModel中的状态变化
    // 比如loading状态、错误状态等
    @weakify(self);
    
    // 示例：如果有按钮状态变化
    // [self.cellViewModel.buttonStateSignal subscribeNext:^(NSNumber *enabled) {
    //     @strongify(self);
    //     // 更新按钮状态
    // }];
}
- (IBAction)tapAction:(UIButton *)sender {
    @weakify(self);
    
    // ✅ 优先使用CellViewModel处理业务逻辑
    if (self.cellViewModel) {
        [[self.cellViewModel.buttonTapCommand execute:sender] subscribeNext:^(id result) {
            @strongify(self);
            
            // 业务逻辑处理完后，再向上传递事件（如果需要）
            if (self->_tapCommand) {
                [self->_tapCommand execute:sender];
            }
            if (self->_tapSubject) {
                [self->_tapSubject sendNext:sender];
            }
        }];
    } else {
        // 兼容没有CellViewModel的情况
        if (_tapCommand) {
            [_tapCommand execute:sender];
        }
        if (_tapSubject) {
            [_tapSubject sendNext:sender];
        }
    }
}

@end
