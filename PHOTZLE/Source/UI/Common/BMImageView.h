//
//  BMImageView.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 11/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMImageView;

@protocol BMImageViewDelegate <NSObject>

- (void)imageViewWasTapped:(BMImageView*)imageView;

@end

@interface BMImageView : UIImageView

@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, assign) id <BMImageViewDelegate> delegate;

- (void)setIndex:(NSInteger)index;

@end
