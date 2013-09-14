//
//  TicTacToeViewController.h
//  TicTacToe
//
//  Created by Jyothidhar Pulakunta on 9/13/13.
//  Copyright (c) 2013 Jyothidhar Pulakunta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicTacToeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *gameState;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img11;
@property (weak, nonatomic) IBOutlet UIImageView *img12;
@property (weak, nonatomic) IBOutlet UIImageView *img13;
@property (weak, nonatomic) IBOutlet UIImageView *img21;
@property (weak, nonatomic) IBOutlet UIImageView *img22;
@property (weak, nonatomic) IBOutlet UIImageView *img23;
@property (weak, nonatomic) IBOutlet UIImageView *img31;
@property (weak, nonatomic) IBOutlet UIImageView *img32;
@property (weak, nonatomic) IBOutlet UIImageView *img33;

- (IBAction)startNewGame:(id)sender;

@end
