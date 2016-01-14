//
//  UIImage+Resize.h
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 19/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)croppedImageWithRect:(CGRect)rect;

- (UIImage *)resizedImageWithSize:(CGSize)size interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

@end
