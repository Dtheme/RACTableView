//
//  DzwTestTabVM.m
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwTestTabVM.h"
#import "DzwTestTabModel.h"
#import "DzwTestTabModel2.h"
#import "DzwTestResponsechainCell.h"

@implementation DzwTestTabVM
#pragma mark - 组装cell和header、footer数据源
- (void)loadData_case2{
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    //cell数据源
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<1; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"标题：row 2";
        cellMd2.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        cellMd2.cellHeight = @(kScale_W(120));
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];
    

}
- (void)loadData{
    //测试cell高度自适应的例子
//    [self loadData_case2];
//    return;
    
    
    
    self.models = [NSArray array];
    self.sectionHeaderModels = [NSArray array];
    self.sectionFooterModels = [NSArray array];
    //cell数据源
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (int i = 0; i<4; ++i) {
        NSMutableArray *t_modelsArr = [NSMutableArray array];
        DzwTestTabModel *cellMd1 = [[DzwTestTabModel alloc]init];
        cellMd1.imageUrl = @"https://pic1.zhimg.com/80/v2-e75d29123341343bb53fbe6c251499f2_r.jpg";
        cellMd1.titleString = @"标题：row 1";
        cellMd1.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        //测试不给高度 自适应高度
        cellMd1.cellNib = [DzwTestTabCell_2 class];
//        cellMd1.cellReuseIdentifier = [NSString stringWithFormat:@"DzwTestTabCell_2_%d",i];
        [t_modelsArr addObject:cellMd1];

        DzwTestTabModel *cellMd2 = [[DzwTestTabModel alloc]init];
        cellMd2.imageUrl = @"img_yj_ms";
        cellMd2.titleString = @"标题：row 2";
        cellMd2.detailString = [NSString stringWithFormat:@"详情：section %d",i];
        cellMd2.cellNib = [DzwTestTabCell class];
        [t_modelsArr addObject:cellMd2];
        
        DzwTestTabModel *cellMd3 = [[DzwTestTabModel alloc]init];
        cellMd3.cellNib = [DzwTestResponsechainCell class];
        cellMd3.cellHeight = @(64);
        [t_modelsArr addObject:cellMd3];
        
        DzwTestTabModel *cellMd4 = [[DzwTestTabModel alloc]init];
        cellMd4.imageUrl = @"img_elective_finish";
        cellMd4.titleString = @"cell内嵌textview高度自适应";
        cellMd4.cellNib = [DzwTestTabCell_4 class];
        cellMd4.cellHeight = @(UITableViewAutomaticDimension);
        [t_modelsArr addObject:cellMd4];

        DzwTestTabModel2 *cell3Md = [self getTestMd2];
        [t_modelsArr addObject:cell3Md];
        [modelsArr addObject:t_modelsArr];
    }
    self.models = [NSArray arrayWithArray:modelsArr];

    //sectionHeader数据源
    NSMutableArray *headerArr = [NSMutableArray array];
    DzwTestTabModel *headerMd1 = [[DzwTestTabModel alloc]init];
    headerMd1.titleString = @"头部标题：section 0";
    headerMd1.detailString = @"头部详情：section 0";
    headerMd1.sectionHeaderHeight = @(kScale_W(80));
    headerMd1.sectionHeaderClass = [DzwTestSectionHeader class];
    [headerArr addObject:headerMd1];

    self.models = [NSArray arrayWithArray:modelsArr];
    DzwTestTabModel *headerMd2 = [[DzwTestTabModel alloc]init];
    headerMd2.titleString = @"头部标题：section 1";
    headerMd2.detailString = @"头部详情：section 1";
    headerMd2.sectionHeaderHeight = @(kScale_W(80));
    headerMd2.sectionHeaderClass = [DzwTestSectionHeader class];
    [headerArr addObject:headerMd2];
    self.sectionHeaderModels = [NSArray arrayWithArray:headerArr];

    //sectionFooter数据源
    NSMutableArray *footerArr = [NSMutableArray array];
    DzwTestTabModel *footerMd1 = [[DzwTestTabModel alloc]init];
    footerMd1.titleString = @"尾部标题：section 0";
    footerMd1.detailString = @"尾部详情：section 0";
    footerMd1.sectionFooterHeight = @(kScale_W(80));
    footerMd1.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd1];

    DzwTestTabModel *footerMd_empty = [DzwTestTabModel new];
    [footerArr addObject:footerMd_empty];

    self.models = [NSArray arrayWithArray:modelsArr];
    DzwTestTabModel *footerMd2 = [[DzwTestTabModel alloc]init];
    footerMd2.titleString = @"尾部标题：section 2";
    footerMd2.detailString = @"尾部详情：section 2";
    footerMd2.sectionFooterHeight = @(kScale_W(80));
    footerMd2.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd2];

    self.models = [NSArray arrayWithArray:modelsArr];
    DzwTestTabModel *footerMd3 = [[DzwTestTabModel alloc]init];
    footerMd3.titleString = @"尾部标题：section 3";
    footerMd3.detailString = @"尾部详情：section 3";
    footerMd3.sectionFooterHeight = @(kScale_W(80));
    footerMd3.sectionFooterClass = [DzwTestSectionFooter class];
    [footerArr addObject:footerMd3];
    self.sectionFooterModels = [NSArray arrayWithArray:footerArr];
}

- (DzwTestTabModel2 *)getTestMd2{
    DzwTestTabModel2 *md = [DzwTestTabModel2 new];
    md.titleString = @"cell内嵌tableView";
    CGFloat height = 0;
    
    NSMutableArray *subModels = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        NSString *subTitle = [NSString stringWithFormat:@"首次揭示PD-L1/PD-1通路在肿瘤微环境免疫逃逸中的作用并首创以抗体阻断PD-1/PD-L1通路治疗癌症的方法，由于这些贡献他在2014年获得全球免疫学界最高奖项William B. Coley Award\n----------------------------------------------\n测试row：%d\n ----------------------------------------------",i];
        CGFloat subCellHeight = [DzwTool getRectByWidth:SCREEN_WIDTH-kScale_W(40) string:subTitle font:kFontWithName(kMedFont, 13.f)].size.height+kScale_W(20);
        height += subCellHeight;
        md.cellHeight = @(height+kScale_W(44)+kScale_W(10));
        
        DzwTestTabModel *md = [DzwTestTabModel new];
        md.cellClass = [DzwTestSubCell class];
        //内嵌cell的高度
        md.cellHeight = @(subCellHeight);
        md.titleString = subTitle;
        [subModels addObject:md];
    }

    md.cellNib = [DzwTestTabCell_3 class];
    md.subCellData = [NSArray arrayWithArray:subModels];
    return md;
}

- (void)loadMore{
    NSLog(@"没写上拉加载的测试代码...");
}
@end
