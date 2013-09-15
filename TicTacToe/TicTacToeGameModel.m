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
@end

@implementation TicTacToeGameModel
@synthesize gameState;

- (id)init {
	if(self = [super init]){
		self.gameState = STATE_CROSS_TURN;
		[self resetBoard];
	}
	return self;
}

- (IconType) getMarkInRow:(int) aRow column:(int) aColumn {
	if (aRow >= NUM_ROWS || aColumn >= NUM_COLS || aRow < 0 || aColumn < 0) {
		return TYPE_EMPTY;
	}
	return gameBoard[aRow][aColumn];
}

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

- (BOOL) resetBoard {
	for (int i=0; i<NUM_ROWS; i++) {
		for (int j=0; j<NUM_COLS; j++) {
			gameBoard[i][j] = TYPE_EMPTY;
		}
	}
	gameState = STATE_CROSS_TURN;
	return true;
}

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
/*
 A player can play perfect tic-tac-toe if they choose the move with the highest priority in the following table[3].
 
 1) Win: If you have two in a row, play the third to get three in a row.
 
 2) Block: If the opponent has two in a row, play the third to block them.
 
 3) Fork: Create an opportunity where you can win in two ways.
 
 4) Block Opponent's Fork:
 
 Option 1: Create two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork or winning. For example, if "X" has a corner, "O" has the center, and "X" has the opposite corner as well, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)
 
 Option 2: If there is a configuration where the opponent can fork, block that fork.
 
 5) Center: Play the center.
 
 6) Opposite Corner: If the opponent is in the corner, play the opposite corner.
 
 7) Empty Corner: Play an empty corner.
 
 8) Empty Side: Play an empty side.
 */
/*
 Then play the move that blocks a winning line, or 
 if there isn't one, play a move at random. Perhaps weight the centre for 3 and the corners for 2, with the edges at 1, but if what you want is an opponent you can beat, you don't want to be to clever.
 */
- (int) iPhoneMove {
	
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
	if (marksMatchType) {
		return YES;
	}
	
	// No winner
	return NO;
}

@end
