//
//  BMPopUpMenuView.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 17/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMPopUpMenuView.h"
#import <QuartzCore/QuartzCore.h>


#define BMPopUpMenuViewTopSpacing 0.0
#define BMPopUpMenuViewBottomSpacing 0.0

CGFloat const BMPopUpMenuViewWidth = 220;
CGFloat const BMPopUpMenuViewHeight = 180;
NSString *const BMShareButtonTitle = @"Share";
NSString *const BMNewPuzzleButtonTitle = @"New Photzle";
NSString *const BMAboutButtonTitle = @"About";
NSString *const BMChooseDismissButtonTitle = @"OK";

@implementation BMPopUpMenuView

- (id)initWithFrame:(CGRect)frame menuType:(BMPopUpMenuType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
//        self.layer.borderWidth = 1;
        
        CGFloat congratulationButtonWidth = [[UIImage imageNamed:@"Blue_behind_congrats_.png"] size].width;
        CGFloat congratulationButtonHeight = [[UIImage imageNamed:@"Blue_behind_congrats_.png"] size].height;
        CGFloat buttonsFrameOriginX = congratulationButtonWidth < BMPopUpMenuViewWidth ? (BMPopUpMenuViewWidth - congratulationButtonWidth) / 2 : 0;
        
        if (type==BMPopUpMenuTypeCongratulation) {
            
            self.congratulationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _congratulationButton.userInteractionEnabled = NO;
            [_congratulationButton setBackgroundImage:[UIImage imageNamed:@"Blue_behind_congrats_.png"] forState:UIControlStateNormal];
             [_congratulationButton sizeToFit];
            UILabel *congratulationButtonLabel = [[UILabel alloc] initWithFrame:CGRectInset(_congratulationButton.frame, 20, 0)];
            congratulationButtonLabel.backgroundColor = [UIColor clearColor];
            congratulationButtonLabel.textColor = [UIColor whiteColor];
            congratulationButtonLabel.textAlignment = NSTextAlignmentCenter;
            congratulationButtonLabel.font = [UIFont systemFontOfSize:14.0];
            congratulationButtonLabel.text = @"Congratulations, you've got it right!";
            congratulationButtonLabel.numberOfLines = 0;
            congratulationButtonLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_congratulationButton addSubview:congratulationButtonLabel]; 
            
            _congratulationButton.frame = CGRectMake(buttonsFrameOriginX, BMPopUpMenuViewTopSpacing, congratulationButtonWidth, congratulationButtonHeight);
            [self addSubview:_congratulationButton];
            
            
            self.sharePuzzleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_sharePuzzleButton addTarget:self action:@selector(sharePuzzle) forControlEvents:UIControlEventTouchUpInside];
            [_sharePuzzleButton setTitle:BMShareButtonTitle forState:UIControlStateNormal];
            [_sharePuzzleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sharePuzzleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_sharePuzzleButton setImage:[UIImage imageNamed:@"Small_share_icon_.png"] forState:UIControlStateNormal];
            [_sharePuzzleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_sharePuzzleButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            
            _sharePuzzleButton.center = self.center;
            [_sharePuzzleButton setFrame:CGRectMake(buttonsFrameOriginX, _congratulationButton.frame.origin.y + _congratulationButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_sharePuzzleButton];
            
            
            self.makeNewPuzzleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_makeNewPuzzleButton addTarget:self action:@selector(makeNewPuzzle) forControlEvents:UIControlEventTouchUpInside];
            [_makeNewPuzzleButton setTitle:BMNewPuzzleButtonTitle forState:UIControlStateNormal];
            [_makeNewPuzzleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_makeNewPuzzleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_makeNewPuzzleButton setImage:[UIImage imageNamed:@"Small_photzle_icon_.png"] forState:UIControlStateNormal];
            [_makeNewPuzzleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_makeNewPuzzleButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            
            [_makeNewPuzzleButton setFrame:CGRectMake(buttonsFrameOriginX, _sharePuzzleButton.frame.origin.y + _sharePuzzleButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_makeNewPuzzleButton];
            
            self.aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_aboutButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
            [_aboutButton setTitle:BMAboutButtonTitle forState:UIControlStateNormal];
            [_aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_aboutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_aboutButton setImage:[UIImage imageNamed:@"Small_about_icon_.png"] forState:UIControlStateNormal];
            [_aboutButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_aboutButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            [_aboutButton setFrame:CGRectMake(buttonsFrameOriginX, _makeNewPuzzleButton.frame.origin.y + _makeNewPuzzleButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_aboutButton];
            
            
            self.dismissViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_dismissViewButton addTarget:self action:@selector(dismissPopUpView) forControlEvents:UIControlEventTouchUpInside];
            [_dismissViewButton setTitle:BMChooseDismissButtonTitle forState:UIControlStateNormal];
            [_dismissViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_dismissViewButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            [_dismissViewButton setFrame:CGRectMake(buttonsFrameOriginX, _aboutButton.frame.origin.y + _aboutButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_dismissViewButton];
        }
        else if (type == BMPopUpMenuTypeRegular){
            
            
            self.sharePuzzleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_sharePuzzleButton addTarget:self action:@selector(sharePuzzle) forControlEvents:UIControlEventTouchUpInside];
            [_sharePuzzleButton setTitle:BMShareButtonTitle forState:UIControlStateNormal];
            [_sharePuzzleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sharePuzzleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_sharePuzzleButton setImage:[UIImage imageNamed:@"Small_share_icon_.png"] forState:UIControlStateNormal];
            [_sharePuzzleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_sharePuzzleButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            
            [_sharePuzzleButton setFrame:CGRectMake(buttonsFrameOriginX, _congratulationButton.frame.origin.y + _congratulationButton.frame.size.height + BMPopUpMenuViewTopSpacing, congratulationButtonWidth, 48)];
            [self addSubview:_sharePuzzleButton];
            
            
            self.makeNewPuzzleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_makeNewPuzzleButton addTarget:self action:@selector(makeNewPuzzle) forControlEvents:UIControlEventTouchUpInside];
            [_makeNewPuzzleButton setTitle:BMNewPuzzleButtonTitle forState:UIControlStateNormal];
            [_makeNewPuzzleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_makeNewPuzzleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_makeNewPuzzleButton setImage:[UIImage imageNamed:@"Small_photzle_icon_.png"] forState:UIControlStateNormal];
            [_makeNewPuzzleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_makeNewPuzzleButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            [_makeNewPuzzleButton setFrame:CGRectMake(buttonsFrameOriginX, _sharePuzzleButton.frame.origin.y + _sharePuzzleButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_makeNewPuzzleButton];
            
            
        
            self.aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_aboutButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
            [_aboutButton setTitle:BMAboutButtonTitle forState:UIControlStateNormal];
            [_aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_aboutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_aboutButton setImage:[UIImage imageNamed:@"Small_about_icon_.png"] forState:UIControlStateNormal];
            [_aboutButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [_aboutButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            [_aboutButton setFrame:CGRectMake(buttonsFrameOriginX, _makeNewPuzzleButton.frame.origin.y + _makeNewPuzzleButton.frame.size.height + 10, congratulationButtonWidth, 48)];
            [self addSubview:_aboutButton];

            
            
            self.dismissViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_dismissViewButton addTarget:self action:@selector(dismissPopUpView) forControlEvents:UIControlEventTouchUpInside];
            [_dismissViewButton setTitle:BMChooseDismissButtonTitle forState:UIControlStateNormal];
            [_dismissViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_dismissViewButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            [_dismissViewButton setFrame:CGRectMake(buttonsFrameOriginX, _aboutButton.frame.origin.y + _aboutButton.frame.size.height + 10, congratulationButtonWidth, 48)];    
            [self addSubview:_dismissViewButton];
        }
        else {
            NSLog(@"Unrecognized menu type");
        }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _dismissViewButton.frame.origin.y + _dismissViewButton.frame.size.height + BMPopUpMenuViewBottomSpacing);
        
    }
    return self;
}


- (void)sharePuzzle
{
    [_delegate shareButtonDidTap:self];
}

- (void)makeNewPuzzle
{
    [_delegate makeNewPuzzleButtonDidTap:self];
}

- (void)dismissPopUpView
{
    [_delegate OKButtonDidTap:self];
}

- (void)showAbout
{
    [_delegate aboutButtonDidTap:self];
}


@end
