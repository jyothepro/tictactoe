//
//  TicTacToeViewController.m
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "TicTacToeViewController.h"

@interface TicTacToeViewController ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	[self configureGame];
}

-(void) addTouchToView:(UIImageView *) img {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [img addGestureRecognizer:tap];
}

-(void) configureView {
	self.gameState.text = @"Player's Turn";
	img11.userInteractionEnabled = YES;
	img11.tag = 1;
	[img11 setImage:[UIImage imageNamed:@""]];
	img12.userInteractionEnabled = YES;
	img12.tag = 2;
	[img12 setImage:[UIImage imageNamed:@""]];
	img13.userInteractionEnabled = YES;
	img13.tag = 3;
	[img13 setImage:[UIImage imageNamed:@""]];
	img21.userInteractionEnabled = YES;
	img21.tag = 4;
	[img21 setImage:[UIImage imageNamed:@""]];
	img22.userInteractionEnabled = YES;
	img22.tag = 5;
	[img22 setImage:[UIImage imageNamed:@""]];
	img23.userInteractionEnabled = YES;
	img23.tag = 6;
	[img23 setImage:[UIImage imageNamed:@""]];
	img31.userInteractionEnabled = YES;
	img31.tag = 7;
	[img31 setImage:[UIImage imageNamed:@""]];
	img32.userInteractionEnabled = YES;
	img32.tag = 8;
	[img32 setImage:[UIImage imageNamed:@""]];
	img33.userInteractionEnabled = YES;
	img33.tag = 9;
    [img33 setImage:[UIImage imageNamed:@""]];
	
	[self addTouchToView:img11];
	[self addTouchToView:img12];
	[self addTouchToView:img13];
	[self addTouchToView:img21];
	[self addTouchToView:img22];
	[self addTouchToView:img23];
	[self addTouchToView:img31];
	[self addTouchToView:img32];
	[self addTouchToView:img33];
}

-(void) configureGame {
	
}

-(void)imageTapped:(UITapGestureRecognizer *)gr {
	NSLog(@"Image was touched %d", gr.view.tag);
	UIImageView *view = (UIImageView *)gr.view;
	view.userInteractionEnabled = NO;
	if (gr.view.tag % 2 == 0) {
		[view setImage:[UIImage imageNamed:@"cross.png"]];
	} else {
		[view setImage:[UIImage imageNamed:@"nought.png"]];
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startNewGame:(id)sender {
	[self configureGame];
	[self configureView];
}

@end
