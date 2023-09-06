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
    self.alphaBtn.titleLabel.font = kFontWithName(kMedFont, 13.f);
    self.alphaBtn.layer.cornerRadius = 5;
    self.alphaBtn.backgroundColor = [HexColor(@"#E9483A") colorWithAlphaComponent:0.3];
    self.alphaBtn.layer.borderColor = HexColor(@"#E9483A").CGColor;
    self.alphaBtn.layer.borderWidth = 0.5;
    self.alphaBtn.layer.masksToBounds = YES;
    
    self.betaBtn.titleLabel.font = kFontWithName(kMedFont, 13.f);
    self.betaBtn.layer.cornerRadius = 5;
    self.betaBtn.backgroundColor = [HexColor(@"#FBBD1C") colorWithAlphaComponent:0.3];
    self.betaBtn.layer.borderColor = HexColor(@"#FBBD1C").CGColor;
    self.betaBtn.layer.borderWidth = 0.5;
    self.betaBtn.layer.masksToBounds = YES;
    
    self.gamaBtn.titleLabel.font = kFontWithName(kMedFont, 13.f);
    self.gamaBtn.layer.cornerRadius = 5;
    self.gamaBtn.backgroundColor = [HexColor(@"#30A14C") colorWithAlphaComponent:0.3];
    self.gamaBtn.layer.borderColor = HexColor(@"#30A14C").CGColor;
    self.gamaBtn.layer.borderWidth = 0.5;
    self.gamaBtn.layer.masksToBounds = YES;
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
    [self routerEventWithName:DzwCellEventName(_cmd) userInfo:@{DzwCellEventName(_cmd):sender,
                                                                DzwCellIndexPath:self.cellModel.indexPath
                                                              }];
}

- (IBAction)gamaAction:(UIButton *)sender {
    [self routerEventWithName:DzwCellEventName(_cmd) userInfo:@{DzwCellEventName(_cmd):sender,
                                                                DzwCellIndexPath:self.cellModel.indexPath
                                                              }];
}

@end
