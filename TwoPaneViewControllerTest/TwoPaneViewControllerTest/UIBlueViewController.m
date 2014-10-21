//
//  UIBlueViewController.m
//  TwoPaneViewControllerTest
//
//  Created by Marcel Ruegenberg on 21.10.14.
//  Copyright (c) 2014 Marcel Ruegenberg. All rights reserved.
//

#import "UIBlueViewController.h"

@interface UIBlueViewController ()

@end

@implementation UIBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 40)];
    [b setTitle:@"Bar" forState:UIControlStateNormal];
    [self.view addSubview:b];
    [b addTarget:self action:@selector(blub:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blub:(id)sender {
    NSLog(@"blublue");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
