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

//Types of Icons on the game board
typedef enum {
	TYPE_NOUGHT,
	TYPE_CROSS,
	TYPE_EMPTY
} IconType;

//Skill level of the iDevice
typedef enum {
	SKILL_NOVICE = 0,
	SKILL_AVERAGE = 2,
	SKILL_EXPERT = 10,
} SkillLevel;

//State of the game
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

//Current Game State
@property (nonatomic) GameState gameState;

// Set the move played by the player
- (BOOL) playerPressedRow:(int) aRow column:(int) aColumn;

//Reset the game board
- (BOOL) resetBoard;

//AI for making the iDevice move
- (int) iPhoneMove;

//Set the skill level of the AI (can be set inbetween the game too)
- (void) setSkillLevel:(SkillLevel) val;

@end
