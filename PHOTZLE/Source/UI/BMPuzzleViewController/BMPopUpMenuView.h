//
//  BMPopUpMenuView.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 17/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMPopUpMenuType) {
    BMPopUpMenuTypeRegular,
    BMPopUpMenuTypeCongratulation
};

extern CGFloat const BMPopUpMenuViewWidth;
extern CGFloat const BMPopUpMenuViewHeight;

@class BMPopUpMenuView;

@protocol BMPopUpMenuViewDelegate <NSObject>

- (void)makeNewPuzzleButtonWasTapped:(BMPopUpMenuView*)popUpView;
- (void)shareButtonWasTapped:(BMPopUpMenuView*)popUpView;
- (void)OKButtonWasTapped:(BMPopUpMenuView*)popUpView;
- (void)aboutButtonWasTapped:(BMPopUpMenuView*)popUpView;

@end

@interface BMPopUpMenuView : UIView

@property (nonatomic, strong) UIButton *congratulationButton;
@property (nonatomic, strong) UIButton *dismissViewButton;
@property (nonatomic, strong) UIButton *makeNewPuzzleButton;
@property (nonatomic, strong) UIButton *sharePuzzleButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, assign) id <BMPopUpMenuViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame menuType:(BMPopUpMenuType)type;
- (void)makeNewPuzzle;
- (void)sharePuzzle;
- (void)showAbout;
- (void)dismissPopUpView;

@end
