//
//  BMImageView.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 11/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMImageView.h"

@interface BMImageView ()

- (void)gestureDidAppear;

@end



@implementation BMImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDidAppear)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
}

- (void)gestureDidAppear
{
    [_delegate imageViewWasTapped:self];
}

@end
