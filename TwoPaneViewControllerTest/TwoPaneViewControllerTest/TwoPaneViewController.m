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

@property (nonatomic) CGFloat currentSplitPosition;
@property CGFloat currentSplitOffset;

@property (strong) UIView *dragView;

@end

@implementation TwoPaneViewControllerView

- (id)init {
    if((self = [super init])) {
        self.dragView = [UIView new];
        self.dragView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.dragView];
    }
    return self;
}

- (void)layoutSubviews {
    UIView *first  = [self viewWithTag:1];
    UIView *second = [self viewWithTag:2];
    CGFloat splitPos = self.currentSplitPosition + self.currentSplitOffset;
    first.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                             splitPos, self.bounds.size.height);
    second.frame = CGRectMake(self.bounds.origin.x + splitPos, self.bounds.origin.y,
                              self.bounds.size.width - splitPos, self.bounds.size.height);
    self.dragView.frame = CGRectMake(second.frame.origin.x - 10, self.frame.origin.y, 20, second.frame.size.height);
    [self bringSubviewToFront:self.dragView];
}

@end



@interface TwoPaneViewController ()

@property BOOL didSetup;
- (void)setCurrentFromFixedSplit;

@end

@implementation TwoPaneViewController

- (void)setCurrentSplitPosition:(CGFloat)currentSplitPosition {
    ((TwoPaneViewControllerView *)self.view).currentSplitPosition = currentSplitPosition;
}

- (CGFloat)currentSplitPosition {
    return ((TwoPaneViewControllerView *)self.view).currentSplitPosition;
}

- (void)setCurrentFromFixedSplit {
    if(self.fixedSplitPosition != 0) {
        if(self.fixedSplitPosition > 0)
            self.currentSplitPosition = self.fixedSplitPosition;
        else // fixedSplitPosition < 0
            self.currentSplitPosition = self.view.bounds.size.width + self.fixedSplitPosition; // sic
        [self.view setNeedsLayout];
    }
}

- (void)setFixedSplitPosition:(CGFloat)fixedSplitPosition {
    if(fixedSplitPosition != _fixedSplitPosition) {
        _fixedSplitPosition = fixedSplitPosition;
        [self setCurrentFromFixedSplit];
    }
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
    UIGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [v.dragView addGestureRecognizer:panner];
}

#define PANE_MIN_SIZE 50
- (void)panned:(UIGestureRecognizer *)gR {
    UIPanGestureRecognizer *panner = (UIPanGestureRecognizer *)gR;
    TwoPaneViewControllerView *v = (TwoPaneViewControllerView *)self.view;
    
    if(panner.state == UIGestureRecognizerStateEnded || panner.state == UIGestureRecognizerStateCancelled) {
        v.currentSplitOffset = 0;
        v.currentSplitPosition = MIN(MAX(0,v.currentSplitPosition + [panner translationInView:v].x), v.bounds.size.width);;
        [v setNeedsLayout];
        
        // TODO: use dynamics in iOS 7+
        CGFloat targetSplitPosition = 0;
        BOOL shouldAnimate = NO;
        if(v.currentSplitPosition < PANE_MIN_SIZE) {
            targetSplitPosition = 0;
            shouldAnimate = YES;
        }
        else if(v.currentSplitPosition > v.bounds.size.width - PANE_MIN_SIZE) {
            targetSplitPosition = v.bounds.size.width;
            shouldAnimate = YES;
        }
        else {
            if(self.fixedSplitPosition != 0) {
                CGFloat fixedSplitAbsPos = self.fixedSplitPosition < 0 ? v.bounds.size.width + self.fixedSplitPosition : self.fixedSplitPosition;
                shouldAnimate = YES;
                if(v.currentSplitPosition < fixedSplitAbsPos / 2) // snap to 0
                    targetSplitPosition = 0.0;
                else if(v.currentSplitPosition < fixedSplitAbsPos + (v.bounds.size.width - fixedSplitAbsPos) / 2 ||
                        v.currentSplitPosition < fixedSplitAbsPos) // snap to split.
                                                                   // predicate is written this way for readability
                    targetSplitPosition = fixedSplitAbsPos;
                else
                    targetSplitPosition = v.bounds.size.width;
            }
        }
        
        if(shouldAnimate) {
            [UIView animateWithDuration:0.3 animations:^{
                v.currentSplitPosition = targetSplitPosition;
                [v setNeedsLayout];
                [v layoutIfNeeded];
            }];
        }
    }
    else { // moving
        v.currentSplitOffset = MIN(MAX(-v.currentSplitPosition, [panner translationInView:v].x), v.bounds.size.width - v.currentSplitPosition);
        [v setNeedsLayout];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstPanelViewController = [UIRedViewController new];
    self.secondPanelViewController = [UIBlueViewController new];
    self.fixedSplitPosition = -320;
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.fixedSplitPosition != 0) {
        if(! self.didSetup) {
            [self setCurrentFromFixedSplit];
            self.didSetup = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ;
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
