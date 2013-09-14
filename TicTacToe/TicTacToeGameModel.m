//
//  TicTacToeGameModel.m
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "TicTacToeGameModel.h"

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
