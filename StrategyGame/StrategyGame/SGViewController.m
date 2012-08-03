//
//  SGViewController.m
//  StrategyGame
//
//  Created by Fletcher Cole on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGViewController.h"


@implementation SGViewController

@synthesize grid;

@synthesize player_1_score;
@synthesize player_2_score;

@synthesize ballVelocity;
@synthesize gameState;


// Deallocate
- (void)dealloc {
    [super dealloc];
    [grid release];
    [player_1_score release];
    [player_2_score release];
}


// Initialize
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [[[NSBundle mainBundle] loadNibNamed:@"SGViewController" owner:self options:nil] objectAtIndex:0];
    }
    
    return self;
}

// View Loading
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    gridCells = nil;
    gameState = kGameStateBlueTurn;
    [self initializeCells:kBoardSize];
    ballVelocity = CGPointMake(kBallSpeedX, kBallSpeedY);
//    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}


// View Unloading
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


// Touch effect
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (gameState == kGameStatePaused) {
//        tapToBegin.hidden = YES;
//        gameState = kGameStateRunning;
//    }
//}


// Main Game Loop
//- (void) gameLoop {
////    if (gameState == kGameStateRunning) {
////        
////        // Move
////        ball.center = CGPointMake(ball.center.x + ballVelocity.x, ball.center.y + ballVelocity.y);
////        
////        // Bounce the ball
////        if (ball.center.x > self.view.bounds.size.width || ball.center.x < 0) {
////            ballVelocity.x = -ballVelocity.x;
////        }
////        
////        if (ball.center.y > self.view.bounds.size.height || ball.center.y < 0) {
////            ballVelocity.y = -ballVelocity.y;
////        }
////    } else if (tapToBegin.hidden) {
////        tapToBegin.hidden = NO;
////    }
//}


//NOTE: Assumes numRowsAndColumns is an odd number
- (void)initializeCells:(NSInteger)numRowsAndColumns
{
    //[gridCells release];
    gridCells = [[NSMutableArray alloc]init];
    
    float xInterval = grid.frame.size.width / numRowsAndColumns;
    float yInterval = grid.frame.size.height / numRowsAndColumns;
    
    float yCounter = -6;//-yInterval / 4.0f;
    
    for (int y = 0; y < numRowsAndColumns; ++y)
    {
        float xCounter = -6;//-xInterval / 4.0f;
        [gridCells addObject:[[NSMutableArray alloc]init]];
        
        for (int x = 0; x < numRowsAndColumns; ++x)
        {
//            NSString* cellName = @"SGGridCell";
            
            float xPos = xCounter;
            if (y % 2 == 0)
                xPos += xInterval / 2.0f;
            
            SGGridCell* cell = [[SGGridCell alloc] initWithFrame:CGRectMake(xPos, yCounter, 52, 52)];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:cell options:nil] objectAtIndex:0];
//                //cell.identifier = cellName;
//            }
            cell.position = CGPointMake(x, y);
            cell.hidden = NO;
            cell.viewController = [self retain];
            cell.userInteractionEnabled = YES;
            
            if ((y % 2 == 0 && x == numRowsAndColumns - 1) // )
                || (y == 0 && (x == 0 || x == kBoardSize - 2))  ||   //NOTE: Can comment out the extra conditional lines to get fuller grid
                (y == 1 && (x == 0 || x == kBoardSize - 1))     ||
                (y == kBoardSize - 1 && (x == 0 || x == kBoardSize - 2))     ||
                (y == kBoardSize - 2 && (x == 0 || x == kBoardSize - 1))     )
            {
                cell.team = INVALID;
                cell.image = nil;
            }
            else if (y < numRowsAndColumns / 2)
            {
                cell.team = PINK;
                cell.image = [UIImage imageNamed: @"GREEiconPurple64.png"];
            }
            else if (y > numRowsAndColumns / 2)
            {
                cell.team = BLUE;
                cell.image = [UIImage imageNamed: @"GREEicon64.png"];
            }
            else
            {
                cell.team = NONE;
                cell.image = [UIImage imageNamed: @"GREEiconBlank64.png"];
            }
            
            //self.grid.backgroundColor = [UIColor redColor];
            [[gridCells objectAtIndex:y] addObject:cell];
            [self.grid addSubview:cell];
            
            xCounter += xInterval;
        }
        
        yCounter += yInterval;
    }
    //[self.view addSubview:grid];
}


// Get the cells neighboring the 
- (NSMutableSet*)getNeighbors:(SGGridCell*)cell
{
    NSMutableSet* set = [[NSMutableSet alloc] init];
    NSInteger x = cell.position.x;
    NSInteger y = cell.position.y;
    bool oddNumberRow = y % 2 != 0;
    
    // up-left
    if (oddNumberRow)
    {
        // If on odd row, up-left.x = x
        if (x - 1 >= 0 && x - 1 < kBoardSize && y - 1 >= 0 && y - 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y - 1] objectAtIndex:x - 1];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    else 
    {
        // If on even row, up-left.x = x - 1
        if (x >= 0 && x < kBoardSize && y - 1 >= 0 && y - 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y - 1] objectAtIndex:x];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    
    // up-right
    if (oddNumberRow)
    {
        // If on odd row, up-right.x = x + 1
        if (x >= 0 && x < kBoardSize && y - 1 >= 0 && y - 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y - 1] objectAtIndex:x];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    else 
    {
        // If on even row, up-right.x = x
        if (x + 1 >= 0 && x + 1< kBoardSize && y - 1 >= 0 && y - 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y - 1] objectAtIndex:x + 1];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    
    // right
    if (x + 1 >= 0 && x + 1 < kBoardSize && y >= 0 && y < kBoardSize)
    {
        SGGridCell* cell = [[gridCells objectAtIndex:y] objectAtIndex:x + 1];
        if (cell.team != INVALID)
            [set addObject:cell];
    }
    
    // down-right
    if (oddNumberRow)
    {
        // If on odd row, down-right.x = x + 1
        if (x >= 0 && x < kBoardSize && y + 1 >= 0 && y + 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y + 1] objectAtIndex:x];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    else 
    {
        // If on even row, down-right.x = x
        if (x + 1 >= 0 && x + 1 < kBoardSize && y + 1 >= 0 && y + 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y + 1] objectAtIndex:x + 1];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    
    // down-left
    if (oddNumberRow)
    {
        if (x - 1 >= 0 && x - 1 < kBoardSize && y + 1 >= 0 && y + 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y + 1] objectAtIndex:x - 1];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    else 
    {
        if (x >= 0 && x < kBoardSize && y + 1 >= 0 && y + 1 < kBoardSize)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y + 1] objectAtIndex:x];
            if (cell.team != INVALID)
                [set addObject:cell];
        }
    }
    
    // left
    if (x - 1 >= 0 && x - 1 < kBoardSize && y >= 0 && y < kBoardSize)
    {
        SGGridCell* cell = [[gridCells objectAtIndex:y] objectAtIndex:x - 1];
        if (cell.team != INVALID)
            [set addObject:cell];
    }
    
    
    // Remove any invalid cells that may have been added
//    NSMutableSet* removes = [[NSMutableSet alloc]init];
//    for (SGGridCell* cell in set)
//    {
//        if (cell.team == INVALID)
//            [removes addObject:[cell retain]];
//    }
//    for (SGGridCell* cell in removes)
//    {
//        [set removeObject:cell];
//    }
//    [removes release];
    
    return set;
}


// Register any changes that need to be made to the board due to player actions
- (void)detectChanges
{
    NSMutableSet* changedCells = [[NSMutableSet alloc] init];
    
    for (int y = 0; y < kBoardSize; ++y)
    {
        for (int x = 0; x < kBoardSize; ++x)
        {
            SGGridCell* cell = [[gridCells objectAtIndex:y] objectAtIndex:x];
            NSMutableSet* neighbors = [self getNeighbors:cell];
            bool swapToBlue = true;
            bool swapToPink = true;
            
            switch(cell.team)
            {
                case PINK:
                    swapToPink = false;
                    for (SGGridCell* neighbor in neighbors)
                    {
                        if (neighbor.team != BLUE)
                        {
                            swapToBlue = false;
                            break;
                        }
                    }
                    break;
                case BLUE:
                    swapToBlue = false;
                    for (SGGridCell* neighbor in neighbors)
                    {
                        if (neighbor.team != PINK)
                        {
                            swapToPink = false;
                            break;
                        }
                    }
                    break;
                case NONE:
                    for (SGGridCell* neighbor in neighbors)
                    {
                        if (neighbor.team != BLUE)
                        {
                            swapToBlue = false;
                            break;
                        }
                    }
                    for (SGGridCell* neighbor in neighbors)
                    {
                        if (neighbor.team != PINK)
                        {
                            swapToPink = false;
                            break;
                        }
                    }
                    break;
                case INVALID:
                default:
                    swapToPink = false;
                    swapToBlue = false;
                    break;
            }
            
            if (swapToBlue)
            {
                cell.swapToBlue = true;
                [changedCells addObject:[cell retain]];
            }
            else if (swapToPink)
            {
                cell.swapToBlue = false;
                [changedCells addObject:[cell retain]];
            }
            [neighbors release];
        }
    }
    
    if (changedCells.count > 0)
    {
        for (SGGridCell* cell in changedCells)
        {
            if (cell.swapToBlue)
            {
                cell.team = BLUE;
                cell.image = [UIImage imageNamed: @"GREEicon64.png"];
            }
            else
            {
                cell.team = PINK;
                cell.image = [UIImage imageNamed: @"GREEiconPurple64.png"];
            }
        }
        [self detectChanges];
    }
    [changedCells release];
}


// Detect whether end game conditions have been reached
- (void)detectEndGame
{
    
}


// Device Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    return YES;
}


@end

