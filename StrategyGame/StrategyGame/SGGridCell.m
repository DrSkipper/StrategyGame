//
//  SGGricCell.m
//  StrategyGame
//
//  Created by Fletcher Cole on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGridCell.h"
#import "SGViewController.h"

@implementation SGGridCell
@synthesize team, position, viewController, swapToBlue;
@synthesize button = _button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[[NSBundle mainBundle] loadNibNamed:@"SGGridCell" owner:self options:nil] objectAtIndex:0];
        viewController = nil;
        self.userInteractionEnabled = YES;
        self.swapToBlue = false;
        [self addSubview:_button];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [viewController release];
    [_button release];
}

- (IBAction)buttonPressed:(id)sender
{
    [self gotPressed];
}

- (void)gotPressed {
    NSMutableSet* neighbors = [viewController getNeighbors:self];
    bool pinkSurrounded = true;
    bool blueSurrounded = true;
    
    for (SGGridCell* neighbor in neighbors)
    {
        if (neighbor.team != PINK)
            pinkSurrounded = false;
        if (neighbor.team != BLUE)
            blueSurrounded = false;
    }
    
    if ((team == PINK || team == NONE) && viewController.gameState == kGameStateBlueTurn && !pinkSurrounded)
    {
        team = BLUE;
        self.image = [UIImage imageNamed: @"GREEicon64.png"];
        viewController.gameState = kGameStatePinkTurn;
    }
    else if ((team == BLUE || team == NONE) && viewController.gameState == kGameStatePinkTurn && !blueSurrounded)
    {
        team = PINK;
        self.image = [UIImage imageNamed:@"GREEiconPurple64.png"];
        viewController.gameState = kGameStateBlueTurn;
    }
    
    [viewController detectChanges];
    [viewController detectEndGame];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    //[super drawRect:rect];
//    // Drawing code
//}


@end
