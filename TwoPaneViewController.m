//
//  TwoPaneViewController.m
//  TwoPaneViewControllerTest
//
//  Created by Marcel Ruegenberg on 21.10.14.
//  Copyright (c) 2014 Marcel Ruegenberg. All rights reserved.
//

#import "TwoPaneViewController.h"

@interface TwoPaneViewControllerView : UIView

@property CGFloat splitSize;
@property TwoPaneMainPosition mainPosition;
@property CGFloat currentSplitOffset;

@property (strong) UIView *dragView;

- (CGFloat)absSplitPos;

@end

@implementation TwoPaneViewControllerView

- (id)init {
    if((self = [super init])) {
        self.dragView = [UIView new];
        self.dragView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dragView];
    }
    return self;
}

- (CGFloat)absSplitPos {
    if(self.mainPosition == TwoPaneMainSecond) return self.splitSize;
    else return self.bounds.size.width - self.splitSize;
}

- (void)layoutSubviews {
    UIView *main  = [self viewWithTag:1];
    UIView *small = [self viewWithTag:2];
    
    CGFloat splitPos0 = [self absSplitPos];
    CGFloat splitPos = splitPos0 + self.currentSplitOffset;
    CGRect firstFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                   splitPos, self.bounds.size.height);
    CGRect secondFrame = CGRectMake(self.bounds.origin.x + splitPos, self.bounds.origin.y,
                                    self.bounds.size.width - splitPos, self.bounds.size.height);
    if(self.mainPosition == TwoPaneMainFirst) {
        main.frame  = firstFrame;
        small.frame = secondFrame;
    }
    else {
        small.frame = firstFrame;
        main.frame  = secondFrame;
    }
    self.dragView.frame = CGRectMake(splitPos - 10, self.bounds.origin.y, 20, self.frame.size.height);
    [self bringSubviewToFront:self.dragView];
}

@end



@interface TwoPaneViewController ()

@property BOOL didSetup;

@end

@implementation TwoPaneViewController

- (void)setSplitSize:(CGFloat)splitSize {
    if(splitSize != _splitSize) {
        _splitSize = splitSize;
        if(! self.didSetup) {
            TwoPaneViewControllerView *v = (TwoPaneViewControllerView *)self.view;
            v.splitSize = splitSize;
        }
    }
}

- (void)setMainPosition:(TwoPaneMainPosition)mainPosition {
    TwoPaneViewControllerView *v = (TwoPaneViewControllerView *)self.view;
    v.mainPosition = mainPosition;
    [v setNeedsLayout];
}

- (TwoPaneMainPosition)mainPosition {
    TwoPaneViewControllerView *v = (TwoPaneViewControllerView *)self.view;
    return v.mainPosition;
}

- (void)setMainPanelViewController:(UIViewController *)content {
    if(content != _mainPanelViewController) {
        if(_mainPanelViewController != nil) {
            [_mainPanelViewController willMoveToParentViewController:nil];
            [_mainPanelViewController.view removeFromSuperview];
            [_mainPanelViewController removeFromParentViewController];
        }
        
        [self addChildViewController:content];
        _mainPanelViewController = content;
        content.view.tag = 1;
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
    }
}

- (void)setSmallPanelViewController:(UIViewController *)content {
    if(content != _smallPanelViewController) {
        if(_smallPanelViewController != nil) {
            [_smallPanelViewController willMoveToParentViewController:nil];
            [_smallPanelViewController.view removeFromSuperview];
            [_smallPanelViewController removeFromParentViewController];
        }
        
        [self addChildViewController:content];
        _smallPanelViewController = content;
        content.view.tag = 2;
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
    }
}

- (void)loadView {
    TwoPaneViewControllerView *v = [TwoPaneViewControllerView new];
    self.view = v;
    if(self.mainPanelViewController.view)
        [v addSubview:self.mainPanelViewController.view];
    if(self.smallPanelViewController.view)
        [v addSubview:self.smallPanelViewController.view];
    UIGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [v.dragView addGestureRecognizer:panner];
}

- (void)panned:(UIGestureRecognizer *)gR {
    UIPanGestureRecognizer *panner = (UIPanGestureRecognizer *)gR;
    TwoPaneViewControllerView *v = (TwoPaneViewControllerView *)self.view;
    
    if(panner.state == UIGestureRecognizerStateEnded || panner.state == UIGestureRecognizerStateCancelled) {
        v.currentSplitOffset = 0;
        v.splitSize = v.splitSize + (v.mainPosition == TwoPaneMainFirst ? -1 : 1) * [panner translationInView:v].x;
        if(v.splitSize < 0) v.splitSize = 0;
        else if(v.splitSize > v.bounds.size.width) v.splitSize = v.bounds.size.width;
        [v setNeedsLayout];
        
        // TODO: use dynamics in iOS 7+
        CGFloat targetSplitPosition = 0;
        if(v.splitSize < 0.5 * self.splitSize) {
            targetSplitPosition = 0;
        }
        else {
            targetSplitPosition = self.splitSize;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            v.splitSize = targetSplitPosition;
            [v setNeedsLayout];
            [v layoutIfNeeded];
        }];
    }
    else { // moving
        CGFloat absSplitPos = [v absSplitPos];
        v.currentSplitOffset = MIN(MAX(-absSplitPos, [panner translationInView:v].x),
                                   v.bounds.size.width - absSplitPos);
        [v setNeedsLayout];
        if(fabs(v.currentSplitOffset) > self.splitSize) { // manually cancel: http://stackoverflow.com/questions/3937831/how-can-i-tell-a-uigesturerecognizer-to-cancel-an-existing-touch
            panner.enabled = NO;
            panner.enabled = YES;
        }
    }
}

@end
