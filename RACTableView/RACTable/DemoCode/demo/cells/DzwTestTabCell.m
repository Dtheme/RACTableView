//
//  DzwTestTabCell.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabCell.h"
#import "DzwTestTabModel.h"

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
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel * _Nullable model) {
        @strongify(self);
        self.imageV.image = kGetImageNamed(model.imageUrl);
        self.titleLb.text = model.titleString;
        self.detailLb.text = model.detailString;
    }];
}
- (IBAction)tapAction:(UIButton *)sender {
    if (_tapCommand) {
        [_tapCommand execute:sender];
    }
    if (_tapSubject) {
        [_tapSubject sendNext:sender];
    }
}

@end
