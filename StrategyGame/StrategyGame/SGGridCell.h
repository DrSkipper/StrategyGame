//
//  SGGricCell.h
//  StrategyGame
//
//  Created by Fletcher Cole on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum team {
    PINK,
    BLUE,
    NONE,
    INVALID
}Team;

@class SGViewController;

@interface SGGridCell : UIImageView
{
    UIButton* _button;
    UIImageView* _powerImage;
}

@property(nonatomic) CGPoint position;
@property(nonatomic) Team team;
@property(nonatomic) bool swapToBlue;
@property(nonatomic, retain) SGViewController* viewController;
@property(nonatomic, retain) IBOutlet UIButton* button;
@property(nonatomic) bool poweredUp;
@property(nonatomic, retain) IBOutlet UIImageView* powerImage;

- (IBAction)buttonPressed:(id)sender;
- (void)gotPressed;

@end
