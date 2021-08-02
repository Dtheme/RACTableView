//
//  ViewController.m
//  RACTable
//
//  Created by Mac on 2021/7/12.
//

#import "ViewController.h"
#import "DzwTestTabVC.h"
#import "TestLoginVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)pushDemo1:(UIButton *)sender {
    TestLoginVC *vc = [TestLoginVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pushDemo2:(id)sender {
    DzwTestTabVC *vc = [DzwTestTabVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
