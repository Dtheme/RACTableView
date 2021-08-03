//
//  DzwTestTabVM.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DzwTestTabCell.h"
#import "DzwTestTabCell_2.h"
#import "DzwTestTabCell_3.h"
#import "DzwTestTabCell_4.h"
#import "DzwTestSubCell.h"
#import "DzwTestSectionHeader.h"
#import "DzwTestSectionFooter.h"
NS_ASSUME_NONNULL_BEGIN

@interface DzwTestTabVM : NSObject

@property (nonatomic, copy) NSArray *models;
@property (nonatomic, copy) NSArray *sectionHeaderModels;
@property (nonatomic, copy) NSArray *sectionFooterModels;
- (void)loadData;
- (void)loadMore;

- (void)loadData_case2;
@end

NS_ASSUME_NONNULL_END
