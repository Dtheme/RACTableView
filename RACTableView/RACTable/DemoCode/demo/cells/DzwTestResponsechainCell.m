//
//  DzwTestResponsechainCell.m
//  RACTable
//
//  Created by dzw on 2023/9/6.
//

#import "DzwTestResponsechainCell.h"
#import "NSObject+RAC.h"
@interface DzwTestResponsechainCell ()
@property (weak, nonatomic) IBOutlet UIButton *alphaBtn;
@property (weak, nonatomic) IBOutlet UIButton *betaBtn;
@property (weak, nonatomic) IBOutlet UIButton *gamaBtn;


@end

@implementation DzwTestResponsechainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)alphaAction:(UIButton *)sender {
    [self routerEventWithName:DzwCellEventName(_cmd) userInfo:@{DzwCellEventName(_cmd):sender,
                                                                DzwCellIndexPath:self.cellModel.indexPath
                                                              }];
}

- (IBAction)betaAction:(UIButton *)sender {
}

- (IBAction)gamaAction:(UIButton *)sender {
}

@end
