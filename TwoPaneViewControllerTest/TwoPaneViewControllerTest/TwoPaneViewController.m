//
//  TwoPaneViewController.m
//  TwoPaneViewControllerTest
//
//  Created by Marcel Ruegenberg on 21.10.14.
//  Copyright (c) 2014 Marcel Ruegenberg. All rights reserved.
//

#import "TwoPaneViewController.h"
#import "UIRedViewController.h"
#import "UIBlueViewController.h"

@interface TwoPaneViewControllerView : UIView

@property CGFloat currentSplitPosition;
@property CGFloat fixedSplitPosition;

@end

@implementation TwoPaneViewControllerView

- (void)layoutSubviews {
    [self viewWithTag:1].frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                            self.currentSplitPosition, self.bounds.size.height);
    [self viewWithTag:2].frame = CGRectMake(self.bounds.origin.x + self.currentSplitPosition, self.bounds.origin.y,
                                            self.bounds.size.width - self.currentSplitPosition, self.bounds.size.height);
}

@end



@interface TwoPaneViewController ()

@end

@implementation TwoPaneViewController

- (void)setCurrentSplitPosition:(CGFloat)currentSplitPosition {
    ((TwoPaneViewControllerView *)self.view).currentSplitPosition = currentSplitPosition;
}

- (CGFloat)currentSplitPosition {
    return ((TwoPaneViewControllerView *)self.view).currentSplitPosition;
}

- (void)setFixedSplitPosition:(CGFloat)fixedSplitPosition {
    ((TwoPaneViewControllerView *)self.view).fixedSplitPosition = fixedSplitPosition;
}

- (CGFloat)fixedSplitPosition {
    return ((TwoPaneViewControllerView *)self.view).fixedSplitPosition;
}

- (void)setFirstPanelViewController:(UIViewController *)content {
    if(content != _firstPanelViewController) {
        if(_firstPanelViewController != nil) {
            [_firstPanelViewController willMoveToParentViewController:nil];
            [_firstPanelViewController.view removeFromSuperview];
            [_firstPanelViewController removeFromParentViewController];
        }
        
        [self addChildViewController:content];
        _firstPanelViewController = content;
        content.view.tag = 1;
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
    }
}

- (void)setSecondPanelViewController:(UIViewController *)content {
    if(content != _secondPanelViewController) {
        if(_secondPanelViewController != nil) {
            [_secondPanelViewController willMoveToParentViewController:nil];
            [_secondPanelViewController.view removeFromSuperview];
            [_secondPanelViewController removeFromParentViewController];
        }
        
        [self addChildViewController:content];
        _secondPanelViewController = content;
        content.view.tag = 2;
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
    }
}

- (void)loadView {
    TwoPaneViewControllerView *v = [TwoPaneViewControllerView new];
    self.view = v;
    if(self.firstPanelViewController.view)
        [v addSubview:self.firstPanelViewController.view];
    if(self.secondPanelViewController.view)
        [v addSubview:self.secondPanelViewController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstPanelViewController = [UIRedViewController new];
    self.secondPanelViewController = [UIBlueViewController new];
    self.currentSplitPosition = 320;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
