//
//  SGViewController.h
//  StrategyGame
//
//  Created by Fletcher Cole on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGGridCell.h"

//NOTE: Board Size should be an odd number
#define kBoardSize 7

#define kGameStatePinkTurn 1
#define kGameStateBlueTurn 2

#define kBallSpeedX 10
#define kBallSpeedY 15

@interface SGViewController : UIViewController {
    IBOutlet UIImageView *grid;
    
    IBOutlet UILabel *player_1_score;
    IBOutlet UILabel *player_2_score;
    
    NSMutableArray *gridCells;
    
    CGPoint ballVelocity;
    
    NSInteger gameState;
}

@property(nonatomic, retain) IBOutlet UIImageView *grid;

@property(nonatomic, retain) IBOutlet UILabel *player_1_score;
@property(nonatomic, retain) IBOutlet UILabel *player_2_score;
@property(nonatomic) NSInteger score1;
@property(nonatomic) NSInteger score2;

@property(nonatomic, retain) NSMutableArray* neutralCells;
@property(nonatomic, retain) SGGridCell* selectedCell;
@property(nonatomic) NSInteger randoSwapCounter;

@property(nonatomic) CGPoint ballVelocity;
@property(nonatomic) NSInteger gameState;

- (void)detectChanges;
- (bool)detectEndGame;
- (void)randoSwap;
- (NSMutableSet*)getNeighbors:(SGGridCell*)cell;

@end
