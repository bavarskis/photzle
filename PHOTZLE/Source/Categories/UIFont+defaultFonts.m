//
//  UIFont+defaultFonts.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 21/09/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "UIFont+defaultFonts.h"

@implementation UIFont (defaultFonts)

+ (UIFont*)defaultRegularFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:size];
    return font;
}

+ (UIFont*)defaultBoldFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    return font;
}

+ (UIFont*)defaultLightFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    return font;
}

@end
