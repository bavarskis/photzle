//
//  BMAboutViewController.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 18/09/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMAboutViewController;

@protocol BMAboutViewControllerDelegate <NSObject>

- (void)aboutViewControllerBackButtonWasTapped:(BMAboutViewController *)aboutViewController;

@end

@interface BMAboutViewController : UIViewController

@property (nonatomic, weak) id <BMAboutViewControllerDelegate> delegate;

@end
