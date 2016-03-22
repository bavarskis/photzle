//
//  BMFloatingMenuPopperView.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 19/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMFloatingMenuPopperView.h"
#import <QuartzCore/QuartzCore.h>

@interface BMFloatingMenuPopperView ()

@property (nonatomic, strong) UILabel *centerLabel;

- (void)handleTap;

@end

@implementation BMFloatingMenuPopperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UIImage *menuImage = [UIImage imageNamed:@"Menu_.png"];
        [self setImage:menuImage forState:UIControlStateNormal];
        
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, 7, 7)];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowPath = shadowPath.CGPath;

    }
    return self;
}


//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *aTouch = [touches anyObject];
//    CGPoint location = [aTouch locationInView:self];
//    CGPoint previousLocation = [aTouch previousLocationInView:self];
//    
//    CGFloat xPosition = location.x-previousLocation.x;
//    CGFloat yPosition = location.y-previousLocation.y;
//
//    self.frame = CGRectOffset(self.frame, xPosition, yPosition);
//}


- (void)handleTap
{
    [_delegate menuPopperDidTap:self];
}

@end
