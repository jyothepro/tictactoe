//
//  TicTacToeViewController.m
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "TicTacToeViewController.h"
#import "TicTacToeGameModel.h"
#import "MBProgressHUD.h"

@interface TicTacToeViewController ()
	@property(nonatomic, retain) NSMutableArray *boardComponents;
	@property(nonatomic, retain) TicTacToeGameModel *game;
@end

@implementation TicTacToeViewController
@synthesize gameState;
@synthesize startNewGameBtn;
@synthesize img11;
@synthesize img12;
@synthesize img13;
@synthesize img21;
@synthesize img22;
@synthesize img23;
@synthesize img31;
@synthesize img32;
@synthesize img33;
@synthesize boardComponents = _boardComponents;
@synthesize game = _game;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_boardComponents = [NSMutableArray arrayWithObjects:img11, img12, img13, img21, img22, img23, img31, img32, img33, nil];
	_game = [TicTacToeGameModel new];
	[self configureView];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion
		  withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self showSkillLevelActionSheet];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Button Index : %d", buttonIndex);
	switch (buttonIndex) {
		case 0:
			[_game setSkillLevel:SKILL_NOVICE];
			break;
			
		case 1:
			[_game setSkillLevel:SKILL_AVERAGE];
			break;
		case 2:
			[_game setSkillLevel:SKILL_EXPERT];
			break;
			
		default:
			break;
	}
}

-(void)showSkillLevelActionSheet {
	NSString *actionSheetTitle = @"Change the skill level";
	NSString *btn1 = @"Novice";
	NSString *btn2 = @"Average";
	NSString *btn3 = @"Expert";
	NSString *cancelTitle = @"Cancel";
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: actionSheetTitle
															 delegate: self
													cancelButtonTitle: cancelTitle
											   destructiveButtonTitle: nil
													otherButtonTitles: btn1, btn2, btn3, nil];
	[actionSheet showInView:self.view];
}

-(void) addTouchToView:(UIImageView *) img {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [img addGestureRecognizer:tap];
}

-(void) configureView {
	self.gameState.text = @"Player's Turn";
	int i = 1;
	for( UIImageView* view in _boardComponents) {
		view.userInteractionEnabled = YES;
		view.tag = i++;
		[view setImage:[UIImage imageNamed:@""]];
		[self addTouchToView:view];
	}
}

-(void)imageTapped:(UITapGestureRecognizer *)gr {
	NSLog(@"Image was touched %d", gr.view.tag);
	[self processGameAction:gr.view.tag];
}

-(void) processGameAction:(int) pos {
	BOOL canAccept = NO;
	GameState curState = [_game gameState];
	switch (pos) {
		case 1:
			canAccept = [_game playerPressedRow:0 column:0];
			break;
			
		case 2:
			canAccept = [_game playerPressedRow:0 column:1];
			break;
			
		case 3:
			canAccept = [_game playerPressedRow:0 column:2];
			break;
			
		case 4:
			canAccept = [_game playerPressedRow:1 column:0];
			break;
			
		case 5:
			canAccept = [_game playerPressedRow:1 column:1];
			break;
			
		case 6:
			canAccept = [_game playerPressedRow:1 column:2];
			break;
			
		case 7:
			canAccept = [_game playerPressedRow:2 column:0];
			break;
			
		case 8:
			canAccept = [_game playerPressedRow:2 column:1];
			break;
			
		case 9:
			canAccept = [_game playerPressedRow:2 column:2];
			break;
			
		default:
			break;
	}
	
	if (canAccept) {
		UIImageView *view = [_boardComponents objectAtIndex:(pos-1)];
		view.userInteractionEnabled = NO;
		if (curState == STATE_CROSS_TURN) {
			[view setImage:[UIImage imageNamed:@"cross.png"]];
			
		} else {
			[view setImage:[UIImage imageNamed:@"nought.png"]];
			
		}
		
		UIAlertView *message;
		switch ([_game gameState]) {
			case STATE_CROSS_TURN:
				self.gameState.text = @"Player's Turn";
				break;
				
			case STATE_NOUGHT_TURN:
				self.gameState.text = @"iPhone's Turn";
				int move = [_game iPhoneMove];
				[self processGameAction:move];
				break;
				
			case STATE_CROSS_WON:
				self.gameState.text = @"Player won the game";
				message = [[UIAlertView alloc] initWithTitle:@"Player Won"
																  message:@"Good Job!!!"
																 delegate:nil
														cancelButtonTitle:@"OK"
														otherButtonTitles:nil];
				[message show];
				
				break;
				
			case STATE_NOUGHT_WON:
				self.gameState.text = @"iPhone won the game";
				message = [[UIAlertView alloc] initWithTitle:@"iPhone Won"
													 message:@"Better luck next time"
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
				[message show];
				break;
				
			case STATE_TIE:
				self.gameState.text = @"Its a tie, try again!";
				message = [[UIAlertView alloc] initWithTitle:@"Its a Tie"
													 message:@"No donut for you"
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
				[message show];
				break;
				
			default:
				break;
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startNewGame:(id)sender {
	[self configureView];
	[_game resetBoard];
}

@end
