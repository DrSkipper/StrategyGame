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
@synthesize team, position, viewController, swapToBlue, poweredUp;
@synthesize button = _button;
@synthesize powerImage = _powerImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[[NSBundle mainBundle] loadNibNamed:@"SGGridCell" owner:self options:nil] objectAtIndex:0];
        viewController = nil;
        self.userInteractionEnabled = YES;
        self.swapToBlue = false;
        [self addSubview:_button];
        self.poweredUp = false;
        self.powerImage.hidden = true;
        [self addSubview:_powerImage];
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

- (void)gotPressed 
{
    // Don't do anything if this is the previously selected cell (can't select same cell that other player did)
    if (self != viewController.selectedCell)
    {
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
        
        bool success = false;
        
        if ((team == PINK || team == NONE) && viewController.gameState == kGameStateBlueTurn && !pinkSurrounded)
        {
            team = BLUE;
            self.image = [UIImage imageNamed: @"GREEicon64.png"];
            viewController.gameState = kGameStatePinkTurn;
            success = true;
        }
        else if ((team == BLUE || team == NONE) && viewController.gameState == kGameStatePinkTurn && !blueSurrounded)
        {
            team = PINK;
            self.image = [UIImage imageNamed:@"GREEiconPurple64.png"];
            viewController.gameState = kGameStateBlueTurn;
            success = true;
        }
        
        if (success)
        {
            viewController.selectedCell.alpha = 1.0f;
            self.alpha = 0.70f;
            viewController.selectedCell = self;
            [viewController detectChanges];
            bool gameEnded = [viewController detectEndGame];
            
            if ([viewController.neutralCells containsObject:self])
                [viewController.neutralCells removeObject:self];
            
            if (!gameEnded)
            {
                if (viewController.randoSwapCounter > 1)
                {
                    [viewController randoSwap];
                    viewController.randoSwapCounter = 0;
                }
                
                // chance to add powerup
                if (arc4random() % 2 == 0 && viewController.neutralCells.count > 0)
                {
                    SGGridCell* cell = [viewController.neutralCells objectAtIndex:(arc4random() % viewController.neutralCells.count)];
                    cell.poweredUp = true;
                    cell.powerImage.hidden = false;
                }
            }
            ++viewController.randoSwapCounter;
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    //[super drawRect:rect];
//    // Drawing code
//}


@end
