//
//  BMPuzzleViewController.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 28/07/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMDifficultyLevel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@class BMPuzzleViewController;

@protocol BMPuzzleViewControllerDelegate <NSObject>

- (void)puzzleViewControllerAttemptedNewPuzzle:(BMPuzzleViewController*)puzzleViewController;

@end

@interface BMPuzzleViewController : UIViewController

@property (nonatomic, weak) id <BMPuzzleViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, strong) BMDifficultyLevel *level;


@end
