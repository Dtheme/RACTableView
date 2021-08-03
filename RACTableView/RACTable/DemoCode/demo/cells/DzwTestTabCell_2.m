//
//  DzwTestTabCell2.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabCell_2.h"
#import "DzwTestTabModel.h"

@implementation DzwTestTabCell_2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightForCellModel:(id<ZGRacModelDelegate>)cellModel{
    return [cellModel.cellHeight floatValue];
}

- (void)bindingCellData{
    @weakify(self);
    [[RACObserve(self, cellModel) skip:1]subscribeNext:^(DzwTestTabModel * _Nullable model) {
        @strongify(self);
        self.titleLb.text = model.titleString;
        self.detailLb.text = model.detailString;
        
        //异步加载图片
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
        [operationQueue addOperation:op];
    }];
}
- (void)downloadImage{
    @weakify(self);
    NSURL *imageUrl = [NSURL URLWithString:((DzwTestTabModel *)self.cellModel).imageUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.imageV.image = image;
    }); 
}
@end
