//
//  BMFloatingMenuPopperView.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 19/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMFloatingMenuPopperView;

@protocol BMFloatingMenuPopperViewDelegate <NSObject>

- (void)menuPopperWasTapped:(BMFloatingMenuPopperView*)popperView;

@end

@interface BMFloatingMenuPopperView : UIButton

@property (nonatomic, assign) id <BMFloatingMenuPopperViewDelegate> delegate;

@end
