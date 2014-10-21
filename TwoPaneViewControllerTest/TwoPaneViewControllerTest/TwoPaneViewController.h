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

@interface TwoPaneViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIViewController *firstPanelViewController;
@property (nonatomic, strong) IBOutlet UIViewController *secondPanelViewController;

// @property TwoPaneSplitDirection splitDirection;

@property (nonatomic) CGFloat currentSplitPosition; // split position / how many pixels in the split direction is the first panel wide / high?

// 0 = no fixing;
// > 0 = size of first panel is fixed
// < 0 = size of second panel is fixed to abs(fixedSplitPosition)
@property (nonatomic) CGFloat fixedSplitPosition;

@end
