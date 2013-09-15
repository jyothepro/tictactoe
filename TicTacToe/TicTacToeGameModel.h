//
//  TicTacToeGameModel.h
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NUM_ROWS 3
#define NUM_COLS 3

typedef enum {
	TYPE_NOUGHT,
	TYPE_CROSS,
	TYPE_EMPTY
} IconType;

typedef enum {
	SKILL_NOVICE = 0,
	SKILL_AVERAGE = 2,
	SKILL_EXPERT = 100,
} SkillLevel;

typedef enum {
	STATE_CROSS_TURN,
	STATE_NOUGHT_TURN,
	STATE_CROSS_WON,
	STATE_NOUGHT_WON,
	STATE_TIE
} GameState;

@interface TicTacToeGameModel : NSObject {
	IconType gameBoard[NUM_ROWS][NUM_COLS];
	GameState gameState;
}

@property (nonatomic) GameState gameState;

- (IconType) getMarkInRow:(int) aRow column:(int) aColumn;
- (BOOL) playerPressedRow:(int) aRow column:(int) aColumn;
- (BOOL) resetBoard;
- (int) iPhoneMove;
- (void) setSkillLevel:(SkillLevel) val;

@end
