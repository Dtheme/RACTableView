//
//  DzwTestSectionHeader.m
//  RACTable
//
//  Created by dzw on 2021/1/6.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestSectionHeader.h"
#import <Masonry.h>
#import "DzwTestTabModel.h"

@interface DzwTestSectionHeader ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation DzwTestSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)sectionViewDidLoad{
    @weakify(self);
    [[RACObserve(self, sectionViewModel) skip:1] subscribeNext:^(DzwTestTabModel *x) {
        @strongify(self);
        self.nameLabel.text = [NSString stringWithFormat:@"header:%@",x.titleString];
        self.contentLabel.text = [NSString stringWithFormat:@"header:%@",x.detailString];
    }];
    self.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.1];
}

#pragma mark - Getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(12);
            make.left.equalTo(self).with.offset(12);
            make.height.equalTo(@(15));
        }];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel).offset(12);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-12);
        }];
    }
    return _contentLabel;
}

@end
