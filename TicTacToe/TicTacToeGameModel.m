//
//  TicTacToeGameModel.m
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "TicTacToeGameModel.h"
#include <stdlib.h>

@interface TicTacToeGameModel()
- (void) _checkForWinner;
- (BOOL) _didWin:(IconType) iconType;
- (BOOL) _isBoardFull;
@property (nonatomic) SkillLevel skillLevel;
@end

@implementation TicTacToeGameModel
@synthesize gameState;
@synthesize skillLevel = _skillLevel;

- (id)init {
	if(self = [super init]){
		//Reset the gameboard
		[self resetBoard];
		
		//Set the skill level to average by default
		[self setSkillLevel:SKILL_AVERAGE];
	}
	return self;
}

// Set the skill level of the AI (can be set inbetween the game too)
- (void) setSkillLevel:(SkillLevel) val {
	_skillLevel = val;
}

// Update the move played by the player
- (BOOL) playerPressedRow:(int) aRow column:(int) aColumn {
	if (aRow >= NUM_ROWS || aColumn >= NUM_COLS ||
		aRow < 0 || aColumn < 0 || gameBoard[aRow][aColumn] != TYPE_EMPTY) {
		return false;
	}
	
	if (gameState == STATE_CROSS_TURN) {
		gameBoard[aRow][aColumn] = TYPE_CROSS;
		gameState = STATE_NOUGHT_TURN;
		[self _checkForWinner];
		return true;
	} else if (gameState == STATE_NOUGHT_TURN) {
		gameBoard[aRow][aColumn] = TYPE_NOUGHT;
		gameState = STATE_CROSS_TURN;
		[self _checkForWinner];
		return true;
	}
	return false;
}

//Reset the gameboard state
- (BOOL) resetBoard {
	for (int i=0; i<NUM_ROWS; i++) {
		for (int j=0; j<NUM_COLS; j++) {
			gameBoard[i][j] = TYPE_EMPTY;
		}
	}
	gameState = STATE_CROSS_TURN;
	return true;
}

// Check if there is a winner or if the game is a tie
- (void) _checkForWinner {
	if ([self _didWin:TYPE_CROSS]) {
		NSLog(@"X won the game");
		gameState = STATE_CROSS_WON;
	} else if ([self _didWin:TYPE_NOUGHT]) {
		NSLog(@"O won the game");
		gameState = STATE_NOUGHT_WON;
	} else if ([self _isBoardFull]) {
		NSLog(@"Tie");
		gameState = STATE_TIE;
	}
}

// Does every position on the gameboard is filled with an icon
- (BOOL) _isBoardFull {
	for (int i=0; i<NUM_ROWS; i++) {
		for (int j=0; j<NUM_COLS; j++) {
			if (gameBoard[i][j] == TYPE_EMPTY) {
				return false;
			}
		}
	}
	return true;
}

//AI for the iPhone move
- (int) iPhoneMove {
	/*
	 AI Logic
	 Based on probability 
		Block the winning move of the opponent is present
	 end;
	 
	 Make a random move based on weights
	 Place the icon in the center if its empty
	 Place the icon in the corners if any available; if multiple available pick one randomly
	 Place the icon in the edges if any available; if multiple available pick one randomly
	 
	 */
	
	//Probability to block a winning move
	if (arc4random_uniform(_skillLevel)) {
		NSLog(@"Block Winning Move");
		//Block a winning move for the opponent
		int blockWinningMove = [self blockOpponentWinningMove];
		if (blockWinningMove) {
			return blockWinningMove;
		}
	}
	
	//Play based on weights
	//Check if center is empty
	if (gameBoard[1][1] == TYPE_EMPTY) {
		return 5;
	}
	
	//Check for corners
	NSMutableArray *freeCorners = [NSMutableArray arrayWithCapacity:4];
	if (gameBoard[0][0] == TYPE_EMPTY) {
		[freeCorners addObject:[NSNumber numberWithInt:1]];
	}
	
	if (gameBoard[0][2] == TYPE_EMPTY) {
		[freeCorners addObject:[NSNumber numberWithInt:3]];
	}
	
	if (gameBoard[2][0] == TYPE_EMPTY) {
		[freeCorners addObject:[NSNumber numberWithInt:7]];
	}
	
	if (gameBoard[2][2] == TYPE_EMPTY) {
		[freeCorners addObject:[NSNumber numberWithInt:9]];
	}
	
	if ([freeCorners count]) {
		int indexToReturn = arc4random() % [freeCorners count];
		return [[freeCorners objectAtIndex:indexToReturn] intValue];
	}
	
	//Check for edges
	NSMutableArray *freeEdges = [NSMutableArray arrayWithCapacity:4];
	if (gameBoard[0][1] == TYPE_EMPTY) {
		[freeEdges addObject:[NSNumber numberWithInt:2]];
	}
	
	if (gameBoard[1][0] == TYPE_EMPTY) {
		[freeEdges addObject:[NSNumber numberWithInt:4]];
	}
	
	if (gameBoard[1][2] == TYPE_EMPTY) {
		[freeEdges addObject:[NSNumber numberWithInt:6]];
	}
	
	if (gameBoard[2][1] == TYPE_EMPTY) {
		[freeEdges addObject:[NSNumber numberWithInt:8]];
	}
	
	if ([freeEdges count]) {
		int indexToReturn = arc4random() % [freeEdges count];
		return [[freeEdges objectAtIndex:indexToReturn] intValue];
	}
	
	return 0;
}

//Select if AI can block any winning move for the opponent
-(int) blockOpponentWinningMove {
	//Block winning row
	int countCross, countEmpty;
	for (int i=0; i<NUM_ROWS; i++) {
		countCross = 0;
		countEmpty = 0;
		for (int j=0; j<NUM_COLS; j++) {
			if (gameBoard[i][j] == TYPE_CROSS) {
				countCross++;
			} else if (gameBoard[i][j] == TYPE_EMPTY) {
				countEmpty++;
			}
		}
		if (countCross == 2 && countEmpty == 1) {
			if (gameBoard[i][0] == TYPE_EMPTY) {
				return i * 3 + 1;
			} else if (gameBoard[i][1] == TYPE_EMPTY) {
				return i * 3 + 2;
			} else {
				return i * 3 + 3;
			}
		}
	}
	
	//Block winning column
	for (int i=0; i<NUM_COLS; i++) {
		countCross = 0;
		countEmpty = 0;
		for (int j=0; j<NUM_ROWS; j++) {
			if (gameBoard[j][i] == TYPE_CROSS) {
				countCross++;
			} else if (gameBoard[j][i] == TYPE_EMPTY) {
				countEmpty++;
			}
		}
		if (countCross == 2 && countEmpty == 1) {
			if (gameBoard[0][i] == TYPE_EMPTY) {
				return i + 1;
			} else if (gameBoard[1][i] == TYPE_EMPTY) {
				return i + 4;
			} else {
				return i + 7;
			}
		}
	}
	
	/*Block winning diagonals*/
	// Check for down diagonal win
	countCross = 0;
	countEmpty = 0;
	for (int i=0; i<NUM_ROWS; i++) {
		if (gameBoard[i][i] == TYPE_CROSS) {
			countCross++;
		} else if (gameBoard[i][i] == TYPE_EMPTY) {
			countEmpty++;
		}
	}
	if (countCross == 2 && countEmpty == 1) {
		if (gameBoard[0][0] == TYPE_EMPTY) {
			return 1;
		} else if (gameBoard[1][1] == TYPE_EMPTY) {
			return 5;
		} else {
			return 9;
		}
	}
	
	// Check for up diagonal win
	countCross = 0;
	countEmpty = 0;
	for (int i=0; i<NUM_ROWS; i++) {
		if (gameBoard[NUM_ROWS-i-1][i] == TYPE_CROSS) {
			countCross++;
		} else if (gameBoard[NUM_ROWS-i-1][i] == TYPE_EMPTY) {
			countEmpty++;
		}
	}
	if (countCross == 2 && countEmpty == 1) {
		if (gameBoard[2][0] == TYPE_EMPTY) {
			return 7;
		} else if (gameBoard[1][1] == TYPE_EMPTY) {
			return 5;
		} else {
			return 3;
		}
	}
	
	return 0;
}

//If icon type won the game
- (BOOL) _didWin:(IconType) iconType {
	BOOL marksMatchType;
	int i,j;
	
	// Check for row win
	for ( i = 0; i<NUM_ROWS; i++) {
		marksMatchType = YES;
		for ( j = 0; j<NUM_COLS; j++) {
			if (iconType != gameBoard[i][j]) {
				marksMatchType = NO;
			}
		}
		if (marksMatchType) {
			return YES;
		}
	}
	
	// Check for column win
	for ( j = 0; j<NUM_COLS; j++) {
		marksMatchType = YES;
		for ( i = 0; i<NUM_ROWS; i++) {
			if (iconType != gameBoard[i][j]) {
				marksMatchType = NO;
			}
		}
		if (marksMatchType) {
			return YES;
		}
	}
	
	// Check for down diagonal win
	marksMatchType = YES;
	for ( i=0; i<NUM_ROWS; i++) {
		if (iconType != gameBoard[i][i]) {
			marksMatchType = NO;
		}
	}
	if (marksMatchType) {
		return YES;
	}
	
	// Check for up diagonal win
	marksMatchType = YES;
	for ( i=0; i<NUM_ROWS; i++) {
		if (iconType != gameBoard[NUM_ROWS-i-1][i]) {
			marksMatchType = NO;
		}
	}
	return marksMatchType;
}

@end
