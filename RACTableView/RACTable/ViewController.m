//
//  ViewController.m
//  RACTable
//
//  Created by Mac on 2021/7/12.
//

#import "ViewController.h"
#import "DzwTestTabVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)pushDemo2:(id)sender {
    DzwTestTabVC *vc = [DzwTestTabVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
