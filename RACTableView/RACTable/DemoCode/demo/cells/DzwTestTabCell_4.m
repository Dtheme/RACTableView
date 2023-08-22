//
//  DzwTestTabCell_4.m
//  RACTable
//
//  Created by dzw on 2021/1/26.
//  Copyright © 2021 dzw. All rights reserved.
//
//  测试cell高度自适应

#import "DzwTestTabCell_4.h"
#import "DzwTestTabModel.h"
@interface DzwTestTabCell_4 ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextView *infoTextV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (nonatomic, strong) DzwTestTabModel *md;
@end

@implementation DzwTestTabCell_4

- (void)awakeFromNib {
    [super awakeFromNib];
    self.infoTextV.delegate = self;
    self.infoTextV.layer.borderColor = [HexColor(@"#FF7E34") colorWithAlphaComponent:0.5].CGColor;
    self.infoTextV.layer.borderWidth = 0.9;
    self.infoTextV.layer.cornerRadius = 5;
    self.infoTextV.backgroundColor = [HexColor(@"#FF7E34") colorWithAlphaComponent:0.2];
    self.infoTextV.scrollEnabled = NO;
}

- (void)bindingCellData{
    @weakify(self);
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel * _Nullable md) {
        @strongify(self);
        self.titleLb.text = md.titleString;
        self.infoTextV.text = md.detailString;
        self.iconImageV.image = kGetImageNamed(md.imageUrl);
    }];
        
    RACChannelTo(self.infoTextV,text) = RACChannelTo(((DzwTestTabModel *)self.cellModel),detailString);
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textViewChanegdCommand) {
        [self.textViewChanegdCommand execute:textView.text];
    }
    ((DzwTestTabModel *)self.cellModel).detailString = textView.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
