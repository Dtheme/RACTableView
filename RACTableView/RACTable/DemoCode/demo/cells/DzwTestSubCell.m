//
//  DzwTestSubCell.m
//  RACTable
//
//  Created by dzw on 2021/1/22.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestSubCell.h"

@interface DzwTestSubCell ()
@property (nonatomic, strong) UILabel *topLB;
@end

@implementation DzwTestSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //标题
        [self.contentView addSubview:self.topLB];
        [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScale_W(20));
            make.right.mas_equalTo(-kScale_W(20));
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)bindingCellData{
    @weakify(self);
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel * _Nullable model) {
        @strongify(self);
        self.topLB.text = model.titleString;
    }];
}
//+ (CGFloat)cellHeightForCellModel:(id<RACModelDelegate>)cellModel{
//    return [cellModel.cellHeight floatValue];
//}

- (UILabel *)topLB{
    if(!_topLB){
        _topLB = [[UILabel alloc]init];
        _topLB.textAlignment = NSTextAlignmentCenter;
        _topLB.textColor = HexColor(@"#5E6BFE");
        _topLB.font = kFontWithName(kMedFont, 13.f);
        _topLB.numberOfLines = 0;
    }
    return _topLB;
}

@end
