//
//  TicTacToeViewController.m
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import "TicTacToeViewController.h"

@interface TicTacToeViewController (){
	NSMutableArray *boardComponents;
}
@property(nonatomic, retain) NSMutableArray *boardComponents;
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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_boardComponents = [NSMutableArray arrayWithObjects:img11, img12, img13, img21, img22, img23, img31, img32, img33, nil];
	[self configureView];
	[self configureGame];
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
