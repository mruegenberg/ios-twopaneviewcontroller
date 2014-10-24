//
//  TwoPaneViewController.h
//  TwoPaneViewControllerTest
//
//  Created by Marcel Ruegenberg on 21.10.14.
//  Copyright (c) 2014 Marcel Ruegenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
typedef enum : NSUInteger {
    TwoPaneSplitDirectionHorizontal,
    TwoPaneSplitDirectionVertical,
} TwoPaneSplitDirection;
 */

typedef enum : NSUInteger {
    TwoPaneMainSecond = 0,
    TwoPaneMainFirst,
} TwoPaneMainPosition;

@protocol TwoPaneViewControllerDelegate;

@interface TwoPaneViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIViewController *mainPanelViewController;
@property (nonatomic, strong) IBOutlet UIViewController *smallPanelViewController;

// @property TwoPaneSplitDirection splitDirection;

@property (nonatomic) CGFloat splitSize;
@property (nonatomic) TwoPaneMainPosition mainPosition;

@property (nonatomic) CGFloat currentSplitPosition; // split position / how many pixels in the split direction is the first panel wide / high?

@property (assign) id<TwoPaneViewControllerDelegate> delegate;

@end



@protocol TwoPaneViewControllerDelegate <NSObject>

- (void)twoPaneViewController:(TwoPaneViewController *)splitController splitMoved:(BOOL)smallPanelHidden;

@end
